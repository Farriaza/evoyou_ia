# EvoYou AI - Requisitos Ubuntu

## Flutter

Versión:
Flutter 3.29.3

Instalación:

git clone https://github.com/flutter/flutter.git ~/flutter

cd ~/flutter

git checkout 3.29.3

export PATH="$PATH:$HOME/flutter/bin"

flutter doctor


---

## Java

Versión requerida:

OpenJDK 17

Instalar:

sudo apt update

sudo apt install openjdk-17-jdk


Verificar:

java -version


---

## Android Studio

Instalar Android Studio oficial.


---

## Android SDK

SDK Platforms:
- Android API 30

SDK Tools:
- Android SDK Platform-Tools
- Android Emulator
- Android SDK Build-Tools


---

## Emulador recomendado

Dispositivo:
Pixel 4a

Configuración:
- API 30
- x86_64
- Android Open Source
- RAM: 2048
- VM Heap: 256
- Graphics: Software
- Snapshots: OFF


---

## Abrir emulador desde terminal

~/Android/Sdk/emulator/emulator -avd Pixel_4a -gpu swiftshader_indirect -no-snapshot


---

## ADB PATH

Agregar al ~/.bashrc:

export PATH=$PATH:$HOME/Android/Sdk/platform-tools

Luego:

source ~/.bashrc


---

## Ejecutar proyecto

cd ~/Escritorio/apk/evoyou_ia

flutter clean

flutter pub get

flutter run


---

## Dependencias Flutter

firebase_core: ^4.0.0
firebase_auth: ^6.0.0
cloud_firestore: ^6.0.0
firebase_storage: ^13.0.1
image_picker: ^1.1.2


---

## Gradle

Gradle recomendado:
8.4


---

## Kotlin

org.jetbrains.kotlin.android
versión:
2.0.21


---

## Java Compatibility

VERSION_17


---

## Problemas comunes

### Broken pipe (32)

Reiniciar:

adb kill-server

adb start-server


### Can't find service: package

Esperar boot completo del emulador o iniciar limpio.


### Emulator corrupto

Cerrar:

pkill -f qemu

Abrir nuevamente:

~/Android/Sdk/emulator/emulator -avd Pixel_4a -wipe-data