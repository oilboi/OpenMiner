#!/bin/bash

echo -n "Which version are you deploying? "
read version

rm -rf deploy/win32/bin/openminer deploy/win64/bin/openminer deploy/linux64/bin/openminer
mkdir -p deploy/win32/bin/openminer deploy/win64/bin/openminer deploy/linux64/bin/openminer

rm -f deploy/*.zip

# Win32
i686-w64-mingw32-cmake -B deploy/win32 . && \
cmake --build deploy/win32 -j8 && \
i686-w64-mingw32-strip deploy/win32/openminer.exe deploy/win32/openminer_server.exe && \
cp deploy/win32/openminer.exe deploy/win32/openminer_server.exe deploy/win32/bin/openminer && \
cp -r docs mods resources texturepacks deploy/win32/bin/openminer && \
mkdir deploy/win32/bin/openminer/config && \
cp config/*.example.lua deploy/win32/bin/openminer/config && \
cp LICENSE *.md deploy/win32/bin/openminer && \
cp /usr/i686-w64-mingw32/bin/libwinpthread-1.dll deploy/win32/bin/openminer && \
cp /usr/i686-w64-mingw32/bin/libssp-0.dll deploy/win32/bin/openminer && \
cd deploy/win32/bin && \
zip -T -r ../../OpenMiner-$version-win32.zip openminer &&
cd ../../..

# Win64
x86_64-w64-mingw32-cmake -B deploy/win64 . && \
cmake --build deploy/win64 -j8 && \
x86_64-w64-mingw32-strip deploy/win64/openminer.exe deploy/win64/openminer_server.exe && \
cp deploy/win64/openminer.exe deploy/win64/openminer_server.exe deploy/win64/bin/openminer && \
cp -r docs mods resources texturepacks deploy/win64/bin/openminer && \
mkdir deploy/win64/bin/openminer/config && \
cp config/*.example.lua deploy/win64/bin/openminer/config && \
cp LICENSE *.md deploy/win64/bin/openminer && \
cp /usr/x86_64-w64-mingw32/bin/libwinpthread-1.dll deploy/win64/bin/openminer && \
cp /usr/x86_64-w64-mingw32/bin/libssp-0.dll deploy/win64/bin/openminer && \
cd deploy/win64/bin && \
zip -T -r ../../OpenMiner-$version-win64.zip openminer &&
cd ../../..

# Linux64
cmake -B deploy/linux64 . && \
cmake --build deploy/linux64 -j8 && \
strip deploy/linux64/openminer deploy/linux64/openminer_server && \
mkdir -p deploy/linux64/bin/openminer/bin deploy/linux64/bin/openminer/lib && \
cp deploy/linux64/openminer deploy/linux64/openminer_server deploy/linux64/bin/openminer/bin && \
cp -r docs mods resources texturepacks deploy/linux64/bin/openminer && \
mkdir deploy/linux64/bin/openminer/config && \
cp config/*.example.lua deploy/linux64/bin/openminer/config && \
cp LICENSE *.md deploy/linux64/bin/openminer && \
cp /usr/lib/ld-linux-x86-64.so.2 \
/usr/lib/libc.so.6 \
/usr/lib/libdl.so.2 \
/usr/lib/libfreetype.so.6 \
/usr/lib/libgcc_s.so.1 \
/usr/lib/libGLdispatch.so.0 \
/usr/lib/libglib-2.0.so.0 \
/usr/lib/libGLU.so.1 \
/usr/lib/libGLX.so.0 \
/usr/lib/libjpeg.so.8 \
/usr/lib/libm.so.6 \
/usr/lib/libpcre.so.1 \
/usr/lib/libpthread.so.0 \
/usr/lib/librt.so.1 \
/usr/lib/libstdc++.so.6 \
/usr/lib/libX11.so.6 \
/usr/lib/libXau.so.6 \
/usr/lib/libxcb.so.1 \
/usr/lib/libXdmcp.so.6 \
/usr/lib/libzstd.so.1 \
    deploy/linux64/bin/openminer/lib && \
echo -e "#!/bin/bash\n./lib/ld-linux-x86-64.so.2 --library-path lib ./bin/openminer \$*" > deploy/linux64/bin/openminer/openminer && \
echo -e "#!/bin/bash\n./lib/ld-linux-x86-64.so.2 --library-path lib ./bin/openminer_server \$*" > deploy/linux64/bin/openminer/openminer_server && \
chmod +x deploy/linux64/bin/openminer/openminer deploy/linux64/bin/openminer/openminer_server && \
cd deploy/linux64/bin && \
zip -T -r ../../OpenMiner-$version-linux64.zip openminer && \
cd ../../..

# Mods and texture packs
cd mods && \
zip -T -r ../deploy/default-$version.zip default && \
zip -T -r ../deploy/creative_inventory-$version.zip creative_inventory && \
cd ../texturepacks && \
zip -T -r ../deploy/minecraft-texturepack-$version.zip minecraft && \
cd ..

