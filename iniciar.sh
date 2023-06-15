#!/bin/bash
rm -rf $2/.git $2/lib.* $2/.gitmodules $2/$1
cp padrao.cpp $2/$1.cpp
cd $2
printf "[gd_resource type=\"GDNativeLibrary\" format=2]\n\n[resource]\nentry/X11.64 = \"res://$1/bin/lib_$1.so\"\ndependency/X11.64 = [  ]">lib.tres

printf "[gd_resource type=\"NativeScript\" load_steps=2 format=2]\n[ext_resource path=\"res://lib.tres\" type=\"GDNativeLibrary\" id=1]\n\n[resource]\nclass_name = \"$1\"\nlibrary = ExtResource( 1 )">lib.gdns

sed -i.bak 's|SimpleClass|'${1}'|g' $1.cpp
git init
git add .
git commit -am "inicio"
mkdir $1
cd $1
mkdir bin
mkdir src

mv ../$1.cpp src/
git submodule add -b 3.4 https://github.com/godotengine/godot-cpp
git submodule update --init --recursive
git clone --recursive https://github.com/godotengine/godot-cpp -b 3.5


cd godot-cpp
scons generate_bindings=yes -j16
cd ..

printf "all:\n\tclang++  -fPIC -o src/$1.o -c src/$1.cpp -g -O3 -std=c++14 -Igodot-cpp/include -Igodot-cpp/include/core -Igodot-cpp/include/gen -Igodot-cpp/godot-headers -pthread\n\tclang++ -o bin/lib_$1.so -shared src/$1.o -Lgodot-cpp/bin \'./godot-cpp/bin/libgodot-cpp.linux.debug.64.a\' -pthread">Makefile
make
cd ..
rm -f *.bak
