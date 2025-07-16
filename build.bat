@ECHO OFF

:: Build API reference
py build-api-reference.py

:: Build Noir
:: See `README.md` for info on how to build Noir
:: Although you're probably on the right track if you're here
py build.py