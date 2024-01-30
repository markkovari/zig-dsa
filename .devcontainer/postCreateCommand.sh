pushd .devcontainer

zls_version="0.11.0"
zls_tar_name="zls-x86_64-linux.tar.gz"
# Install ZLS
pushd zls
if [ -f $zls_tar_name ]; then
    echo "current version of zls ${zls_version} exists, skipping download"
else
    wget $"https://github.com/zigtools/zls/releases/download/${zls_version}/${zls_tar_name}"
    tar -x --strip-components=1 -f "$zls_tar_name" --no-same-owner
fi
chmod -R 777 ./bin/
popd

# Install zig
pushd zig
zig_version="0.12.0-dev.2341+92211135f"
zig_tar_name="zig-linux-x86_64-${zig_version}.tar.xz"
if [ -f $zig_tar_name]; then
    echo "current version of zig ${zig_version} exists, skipping download"
else 
    wget "https://ziglang.org/builds/zig-linux-x86_64-${zig_version}.tar.xz"
    tar -x --strip-components=1 -f $zig_tar_name --no-same-owner
fi
chmod -R 777 ./zig
popd
popd