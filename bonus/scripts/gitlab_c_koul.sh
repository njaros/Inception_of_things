#!/bin/bash

HOST=http://localhost:8080/

RAW_RESPONSE=$(curl -L -i ${HOST}users/sign_in)

# Use quotes when echoing to preserve formatting
# echo "$RAW_RESPONSE"

# Extract cookie (use quotes around variable)
COOKIE=$(echo "$RAW_RESPONSE" | grep 'Set-Cookie' | grep '_gitlab_session' | sed 's/.*_gitlab_session=\([^;]*\).*/\1/')
# echo "Cookie: $COOKIE"

# Extract CSRF token (use quotes around variable)
CSRF_TOKEN=$(echo "$RAW_RESPONSE" | grep -i 'csrf-token' | sed 's/.*content="\([^"]*\)".*/\1/')
# echo "CSRF Token: $CSRF_TOKEN"

PASSWORD=$(cat ../gitlab_password.txt)

# Make the POST request with the extracted cookie, and include CSRF token in the body
RESPONSE=`curl -L -X POST ${HOST}users/sign_in \
  -H "Cookie: _gitlab_session=${COOKIE}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Connection: keep-alive" \
  -d "user[login]=root&user[password]=${PASSWORD}&authenticity_token=${CSRF_TOKEN}&user[remember_me]=0" \
  -i`
# echo "response: $RESPONSE"

KNOWN_SIGN_IN=$(echo "$RESPONSE" | grep Set-Cookie | grep known_sign_in | sed 's/.*known_sign_in=\([^;]*\).*/\1/')
# echo "known sign in: $KNOWN_SIGN_IN"

SETTING_CHANGED_RESPONSE=`curl -L -X POST ${HOST}admin/application_settings/general \
  -H "Cookie: _gitlab_session=${COOKIE};known_sign_in=${KNOWN_SIGN_IN}" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Connection: keep-alive" \
  -d "_method=patch&authenticity_token=${CSRF_TOKEN}&application_setting[import_sources][]=&application_setting[import_sources][]=git&\
  application_setting[import_sources][]=git&\
  application_setting[project_export_enabled]=0&\
  application_setting[project_export_enabled]=1&\
  application_setting[bulk_import_enabled]=0&\
  application_setting[silent_admin_exports_enabled]=0&\
  application_setting[max_export_size]=0&\
  application_setting[max_import_size]=0&\
  application_setting[max_import_remote_file_size]=10240&\
  application_setting[bulk_import_max_download_file_size]=5120&\
  application_setting[max_decompressed_archive_size]=25600&\
  application_setting[decompress_archive_file_timeout]=210&\
  application_setting[concurrent_github_import_jobs_limit]=1000&\
  application_setting[concurrent_bitbucket_import_jobs_limit]=100&\
  application_setting[concurrent_bitbucket_server_import_jobs_limit]=100" \
  -i`
echo "known sign in: $SETTING_CHANGED_RESPONSE"