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
# RESPONSE=`curl -L -X POST ${HOST}users/sign_in \
#   -H "Cookie: _gitlab_session=${COOKIE}" \
#   -H "Content-Type: application/x-www-form-urlencoded" \
#   -H "Connection: keep-alive" \
#   -d "user[login]=root&user[password]=${PASSWORD}&authenticity_token=${CSRF_TOKEN}&user[remember_me]=0" \
#   -i`

REPONSE2=`curl -L -X POST ${HOST}/users/sign_in \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" \
  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" \
  -H "Accept-Language: en-US,en;q=0.5" \
  -H "Accept-Encoding: gzip, deflate, br" \
  -H "Referer: ${HOST}/users/sign_in" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Origin: ${HOST}" \
  -H "Connection: keep-alive" \
  -H "Cookie: _gitlab_session=${COOKIE}; preferred_language=en" \
  -H "Upgrade-Insecure-Requests: 1" \
  -H "Sec-Fetch-Dest: document" \
  -H "Sec-Fetch-Mode: navigate" \
  -H "Sec-Fetch-Site: same-origin" \
  -H "Sec-Fetch-User: ?1" \
  --data-raw "authenticity_token=${CSRF_TOKEN}&user%5Blogin%5D=root&user%5Bpassword%5D=${PASSWORD}&user%5Bremember_me%5D=0" \
  -i`
# echo "response: $REPONSE2"

KNOWN_SIGN_IN=$(echo "$RESPONSE" | grep Set-Cookie | grep known_sign_in | sed 's/.*known_sign_in=\([^;]*\).*/\1/')
# echo "known sign in: $KNOWN_SIGN_IN"

# SETTING_CHANGED_RESPONSE=`curl -L -X POST ${HOST}admin/application_settings/general \
#   -H "Cookie: _gitlab_session=${COOKIE};known_sign_in=${KNOWN_SIGN_IN}" \
#   -H "Content-Type: application/x-www-form-urlencoded" \
#   -H "Connection: keep-alive" \
#   -d "_method=patch&authenticity_token=${CSRF_TOKEN}&application_setting[import_sources][]=&application_setting[import_sources][]=git&\
#   application_setting[import_sources][]=git&\
#   application_setting[project_export_enabled]=0&\
#   application_setting[project_export_enabled]=1&\
#   application_setting[bulk_import_enabled]=0&\
#   application_setting[silent_admin_exports_enabled]=0&\
#   application_setting[max_export_size]=0&\
#   application_setting[max_import_size]=0&\
#   application_setting[max_import_remote_file_size]=10240&\
#   application_setting[bulk_import_max_download_file_size]=5120&\
#   application_setting[max_decompressed_archive_size]=25600&\
#   application_setting[decompress_archive_file_timeout]=210&\
#   application_setting[concurrent_github_import_jobs_limit]=1000&\
#   application_setting[concurrent_bitbucket_import_jobs_limit]=100&\
#   application_setting[concurrent_bitbucket_server_import_jobs_limit]=100" \
#   -i`

# SETTING_CHANGED_RESPONSE=`curl 'http://gitlab.localhost:8080/admin/application_settings/general#js-import-export-settings' -X POST \
#   -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0' \
#   -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
#   -H 'Accept-Language: en-US,en;q=0.5' \
#   -H 'Accept-Encoding: gzip, deflate, br' \
#   -H 'Referer: http://gitlab.localhost:8080/admin/application_settings/general' \
#   -H 'Content-Type: application/x-www-form-urlencoded' \
#   -H 'Origin: http://gitlab.localhost:8080' \
#   -H 'Connection: keep-alive' \
#   -H 'Cookie: known_sign_in=${KNOWN_SIGN_IN}; preferred_language=en; _gitlab_session=${COOKIE}' \
#   -H 'Upgrade-Insecure-Requests: 1' \
#   -H 'Sec-Fetch-Dest: document' \
#   -H 'Sec-Fetch-Mode: navigate' \
#   -H 'Sec-Fetch-Site: same-origin' \
#   -H 'Sec-Fetch-User: ?1' \
#   --data-raw '_method=patch&authenticity_token=${CSRF_TOKEN}&application_setting%5Bimport_sources%5D%5B%5D=&application_setting%5Bimport_sources%5D%5B%5D=git&application_setting%5Bproject_export_enabled%5D=0&application_setting%5Bproject_export_enabled%5D=1&application_setting%5Bbulk_import_enabled%5D=0&application_setting%5Bsilent_admin_exports_enabled%5D=0&application_setting%5Bmax_export_size%5D=0&application_setting%5Bmax_import_size%5D=0&application_setting%5Bmax_import_remote_file_size%5D=10240&application_setting%5Bbulk_import_max_download_file_size%5D=5120&application_setting%5Bmax_decompressed_archive_size%5D=25600&application_setting%5Bdecompress_archive_file_timeout%5D=210&application_setting%5Bconcurrent_github_import_jobs_limit%5D=1000&application_setting%5Bconcurrent_bitbucket_import_jobs_limit%5D=100&application_setting%5Bconcurrent_bitbucket_server_import_jobs_limit%5D=100' \
#   -i`
# echo "known sign in: $SETTING_CHANGED_RESPONSE"

TRUE=`curl "${HOST}/admin/application_settings/general#js-import-export-settings" -X POST \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" \
  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" \
  -H "Accept-Language: en-US,en;q=0.5" \
  -H "Accept-Encoding: gzip, deflate, br" \
  -H "Referer: ${HOST}/admin/application_settings/general" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Origin: ${HOST}" \
  -H "Connection: keep-alive" \
  -H "Cookie: _gitlab_session=${COOKIE}; preferred_language=en; known_sign_in=${KNOWN_SIGN_IN}" \
  -H "Upgrade-Insecure-Requests: 1" \
  -H "Sec-Fetch-Dest: document" \
  -H "Sec-Fetch-Mode: navigate" \
  -H "Sec-Fetch-Site: same-origin" \
  -H "Sec-Fetch-User: ?1" \
  --data-raw "_method=patch&authenticity_token=${CSRF_TOKEN}&application_setting%5Bimport_sources%5D%5B%5D=&application_setting%5Bimport_sources%5D%5B%5D=git&application_setting%5Bproject_export_enabled%5D=0&application_setting%5Bproject_export_enabled%5D=1&application_setting%5Bbulk_import_enabled%5D=0&application_setting%5Bsilent_admin_exports_enabled%5D=0&application_setting%5Bmax_export_size%5D=0&application_setting%5Bmax_import_size%5D=0&application_setting%5Bmax_import_remote_file_size%5D=10240&application_setting%5Bbulk_import_max_download_file_size%5D=5120&application_setting%5Bmax_decompressed_archive_size%5D=25600&application_setting%5Bdecompress_archive_file_timeout%5D=210&application_setting%5Bconcurrent_github_import_jobs_limit%5D=1000&application_setting%5Bconcurrent_bitbucket_import_jobs_limit%5D=100&application_setting%5Bconcurrent_bitbucket_server_import_jobs_limit%5D=100" \
  -i`

echo "haha : ${TRUE}"