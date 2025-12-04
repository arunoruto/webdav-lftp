---
name: WebDAV / Copyparty Pages
description: Deploy static sites to Copyparty or sync files to any WebDAV server using lftp.
author: You
tags: [webdav, lftp, copyparty, pages, deploy, static-site]
containerImage: your-docker-user/woodpecker-webdav-lftp
containerImageUrl: https://hub.docker.com/r/your-docker-user/woodpecker-webdav-lftp
url: https://github.com/your-user/woodpecker-plugin-webdav
---

# WebDAV / Copyparty Pages Plugin

A generic WebDAV uploader powered by `lftp`, optimized for deploying static sites to **Copyparty** (acting as a Pages server) or Nextcloud/Apache.

Unlike simple `curl` scripts, this plugin uses `lftp mirror` to ensure a robust sync:

- **Recursive Creation:** Automatically creates missing parent directories on the server.
- **Exact Sync:** Supports deleting remote files that no longer exist locally (clean up old assets).
- **Smart Uploads:** Only uploads files that have changed (based on size/timestamp).

## Settings

| Name         | Description                                                                                               | Default           |
| ------------ | --------------------------------------------------------------------------------------------------------- | ----------------- |
| `url`        | The base WebDAV URL (e.g., `https://dav.example.com`).                                                    | **Required**      |
| `username`   | WebDAV username.                                                                                          | **Required**      |
| `password`   | WebDAV password (use `from_secret`).                                                                      | **Required**      |
| `source`     | Local folder to upload (e.g., `dist/` or `public/`).                                                      | `.` (Current Dir) |
| `target`     | Remote subdirectory to upload into.                                                                       | `/`               |
| `delete`     | **Dangerous:** Delete remote files that are missing locally. Great for static sites to remove old JS/CSS. | `false`           |
| `verify_ssl` | Verify SSL certificates. Set to `false` for self-signed certs.                                            | `true`            |
| `verbose`    | Enable debug logging for lftp.                                                                            | `false`           |

## Examples

### Deploy to Copyparty Pages

This example deploys a built static site to a Copyparty server configured with a `/w` volume for websites.

```yaml
steps:
  deploy-pages:
    image: your-docker-user/woodpecker-webdav-lftp
    settings:
      # The base URL of your Copyparty instance
      url: [https://copyparty.example.com](https://copyparty.example.com)
      username: my-upload-user
      password:
        from_secret: webdav_password

      # The folder containing your built HTML/CSS
      source: dist/

      # The path on the server (e.g. /w/my-repo-name)
      target: /w/${CI_REPO_NAME}/

      # Clean up old files on the server
      delete: true
```

Simple File Sync

Sync the current directory to a WebDAV folder without deleting anything.

```yaml
steps:
  upload:
    image: your-docker-user/woodpecker-webdav-lftp
    settings:
      url: [https://nextcloud.example.com/remote.php/dav/files/user/](https://nextcloud.example.com/remote.php/dav/files/user/)
      username: myuser
      password:
        from_secret: nc_password
      target: /backups/${CI_REPO_NAME}/
```
