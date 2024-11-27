@echo off

git clone https://github.com/juice-shop/juice-shop

cd juice-shop 

docker build -t juice-shop .

