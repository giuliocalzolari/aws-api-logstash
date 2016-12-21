
cd ./lambda/function/
for f in $(ls -1 ./*.py |  sed -e 's/^..//' |  sed -e 's/\..*$//'); do 
   echo "zip $f"
   rm -rf "${f}.zip"
   zip -q "${f}.zip" "${f}.py" 
done
cd ../../

echo "Run:  terraform apply"
terraform apply


# rm -rf ./lambda/function/*.zip
