echo Compilando os objetos.....

set scriptdir=.\

set exec_script=all_scripts.sql

for /F %%G in ('dir /b %scriptdir%\*.sql') do (
  echo.@%%~fG >> %exec_script%
)

echo.--script end >> %exec_script%
echo.exit >> %exec_script%

C:\oraclexe\app\oracle\product\11.2.0\server\bin\sqlplus -L -S dnoda/dnoda @%exec_script%

del %exec_script%
