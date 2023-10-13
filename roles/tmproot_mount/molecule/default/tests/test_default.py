"""Role testing files using testinfra."""


def test_tmproot_mutex(host):
    f = host.file("/var/lock/tmproot")
    assert f.exists


def test_root_mount(host):
    assert not host.mount_point("/mnt/root").exists


def test_tmproot_mount(host):
    for mount_point in host.mount_point.get_mountpoints():
        if mount_point.path == "/":
            assert mount_point.filesystem == "tmpfs"
            return
    else:
        raise AssertionError("tmproot not mounted")
