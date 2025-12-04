# Woodpecker WebDAV & Copyparty Pages Plugin

A [Woodpecker CI](https://woodpecker-ci.org/) plugin to sync files to a WebDAV server using `lftp`.

While generic enough for any WebDAV server (Nextcloud, Apache mod_dav), this plugin was specifically tuned to work with [Copyparty](https://github.com/9001/copyparty) to create a self-hosted "GitHub Pages" alternative.

## Features

- **Mirror Mode:** Exact synchronization of folders (only uploads changed files).
- **Auto-Mkdir:** Automatically creates the folder structure on the server (solves the common "parent directory missing" error).
- **Atomic-ish:** Uses `lftp` which handles retries and connection issues much better than `curl`.
- **Cleanup:** Optional support for deleting remote files that have been removed from the source (`delete: true`).
- **Permissions:** Handles obscure Apache/WebDAV permission flags automatically.

## Usage

### Deploying a Static Site (Copyparty Pages)

```yaml
steps:
  deploy:
    image: your-docker-user/woodpecker-webdav-lftp
    settings:
      # The URL to your Copyparty server
      url: [https://pages.intranet.local](https://pages.intranet.local)
      username: admin
      password:
        from_secret: webdav_pass

      # Local folder containing your built site (e.g. dist, public, build)
      source: public/

      # Remote destination path (e.g. the volume /w/ plus the site name)
      target: /w/${CI_REPO_NAME}/

      # Remove old files on the server to keep it clean
      delete: true
```

### Generic File Sync

```yaml
steps:
  upload-report:
    image: your-docker-user/woodpecker-webdav-lftp
    settings:
      url: [https://nextcloud.example.com/remote.php/dav/files/myuser/](https://nextcloud.example.com/remote.php/dav/files/myuser/)
      username: myuser
      password:
        from_secret: nc_pass
      source: ./reports/
      target: /Documents/CI-Reports/
      verify_ssl: false
```

## Settings

| Setting      | Type    | Description                                                                      | Default           |
| :----------- | :------ | :------------------------------------------------------------------------------- | :---------------- |
| `url`        | string  | **Required**. The entry point URL for the WebDAV server.                         |                   |
| `username`   | string  | **Required**. WebDAV username.                                                   |                   |
| `password`   | string  | **Required**. WebDAV password. It is recommended to use `from_secret`.           |                   |
| `source`     | string  | The local directory to upload.                                                   | `.` (current dir) |
| `target`     | string  | The absolute path on the server to upload to.                                    | `/`               |
| `delete`     | boolean | If `true`, deletes files on the destination that do not exist in the source.     | `false`           |
| `verify_ssl` | boolean | If `false`, disables SSL certificate verification (useful for internal servers). | `true`            |
| `verbose`    | boolean | If `true`, prints detailed lftp debug logs.                                      | `false`           |

## Building Locally

If you want to modify or build this plugin yourself:
Bash

```sh
# Build the image
docker build -t woodpecker-webdav-lftp .

# Test it locally (using environment variables to simulate settings)
docker run --rm \
  -e PLUGIN_URL="http://localhost:8081" \
  -e PLUGIN_USERNAME="admin" \
  -e PLUGIN_PASSWORD="password" \
  -e PLUGIN_SOURCE="./dist" \
  -e PLUGIN_TARGET="/w/test-site" \
  -v $(pwd):/woodpecker/src \
  -w /woodpecker/src \
  woodpecker-webdav-lftp
```

## License

MIT
