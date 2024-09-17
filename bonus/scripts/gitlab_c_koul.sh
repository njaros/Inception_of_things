RAW_RESPONSE=`curl -L -v http://localhost:8181/users/sing_in 2>&1`
echo $RAW_RESPONSE
COOKIE=`echo $RAW_RESPONSE | grep Set-Cookie | grep _gitlab_session | sed 's/.*_gitlab_session=\([^;]*\).*/\1/'`
echo $COOKIE