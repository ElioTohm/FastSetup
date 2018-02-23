cd /tmp || exit
echo "Downloading Postman ..."
wget -q https://dl.pstmn.io/download/latest/linux?arch=64 -O postman.tar.gz
tar -xzf postman.tar.gz
rm postman.tar.gz

echo "Installing to opt..."
if [ -d "/opt/Postman" ];then
    rm -rf /opt/Postman
fi
mv Postman /opt/Postman

echo "Creating symbolic link..."
if [ -L "/usr/bin/postman" ];then
    rm -f /usr/bin/postman
fi
ln -s /opt/Postman/Postman /usr/bin/postman

echo "Installation completed successfully."
echo "You can use Postman!"
