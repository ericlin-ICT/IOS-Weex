#!/bin/sh

KEY="4345756f4765505a5a7257676a6b6659"
IV="514f7675504c7179534468566a616a43"

WORK_DIR=`pwd`
echo "packaging at work dir: ${WORK_DIR}"
echo "start packaging..."
#find . -name "*.lua"|zip patch_tmp.zip -@
zip patch_tmp.zip patch/*
echo "finish packaging..."
echo "start encrypting"
openssl enc -aes-128-cbc -in patch_tmp.zip -out patch_enc.zip -K $KEY -iv $IV
rm patch_tmp.zip
echo "finish encrypting"
echo "start packaging again"
zip patch.zip patch_enc.zip
rm patch_enc.zip
echo "end of packaging again"
echo `md5 patch.zip`
#openssl aes-256-cbc -d -in patch.zip.enc -out patch.zip.dec -K $KEY -iv $IV
#echo "$KEY|$IV" > aes.txt
#openssl rsautl -encrypt -inkey pub.pem -pubin -in aes.txt | openssl enc -base64
