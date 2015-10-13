# ArchLinux repository server with embedded AWS S3 back-end

This is a logical extension of the [cross-dev/arch-repo-server](https://github.com/cross-dev/arch-repo-server).
It embeds [s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse) application to provide S3 bucket access through a
FUSE mountpoint.

## Install

Have Docker installed and run:

```
$ docker pull crossdev/arch-repo-server-s3
```

The image inherits from [crossdev/arch-repo-server](https://hub.docker.com/r/crossdev/arch-repo-server/) and its
build will automatically trigger once the ancestor is built successfully.

## Use

The image has a handful of parameters to configure before it can do anything useful for you. Here is an example
command line:

```
$ docker run -d \
    -p 8000:41268 \
    --env-file=/etc/arch-repo-server.conf \
    --cap-add mknod --cap-add sys_admin --device=/dev/fuse \
    crossdev/arch-repo-server-s3
```

Now, lets explain each of these intriguing bits:

* `--env-file=/etc/arch-repo-server.conf` - this file configures some sensitive environment variables (see below)
* `--cap-add ... --device` - this is necessary to make FUSE mounting succeed inside a container, `--privileged` is
an unsafe shorthand (avoid it)

### Configuration file

The format of the file is as follows:

```
S3_BUCKET=bucket
S3_ACCESS=Access
S3_SECRET=Secret
```
, where

* `S3_BUCKET` - name of the target S3 bucket
* `S3_ACCESS` - AWS access key
* `S3_SECRET` - AWS secret key

Make sure the file can not be read by someone who should not read it.
