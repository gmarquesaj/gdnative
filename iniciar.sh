#!/bin/bash

printf '[gd_resource type="GDNativeLibrary" format=2]\n\n[resource]\nentry/X11.64 = "res://SimpleLibrary/bin/libt'$1'.so"\ndependency/X11.64 = [  ]'>lib.tres

printf '[gd_resource type="NativeScript" load_steps=2 format=2]\n[ext_resource path="res://lib.tres" type="GDNativeLibrary" id=1]\n\n[resource]\nclass_name = "'$1'"\nlibrary = ExtResource( 1 )'>lib.gdns
cp padrao.cpp $1.cpp
sed -i.bak 's|SimpleClass|'${1}'|g' $1.cpp
git init
git add .
git commit -am "inicio"
mkdir SimpleLibrary
cd SimpleLibrary
mkdir bin
mkdir src

mv ../init.cpp src/
git submodule add -b 3.4 https://github.com/godotengine/godot-cpp
git submodule update --init --recursive
#git clone --recursive https://github.com/godotengine/godot-cpp -b 3.4


cd godot-cpp
scons generate_bindings=yes -j8
cd ..

clang++ -fPIC -o src/init.o -c src/init.cpp -g -O3 -std=c++14 -Igodot-cpp/include -Igodot-cpp/include/core -Igodot-cpp/include/gen -Igodot-cpp/godot-headers -pthread

clang++ -o bin/libtest.so -shared src/init.o -Lgodot-cpp/bin './godot-cpp/bin/libgodot-cpp.linux.debug.64.a' -pthread
