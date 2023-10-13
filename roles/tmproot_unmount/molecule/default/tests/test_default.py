"""Role testing files using testinfra."""


def test_hosts_file(host):
    """Validate /etc/hosts file."""
    f = host.file("/etc/hosts")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"


def test_tmproot_mutex(host):
    assert not host.file("/var/lock/tmproot").exists


def test_root_mount(host):
    assert not host.mount_point("/mnt/root").exists


def test_tmproot_mount(host):
    for mount_point in host.mount_point.get_mountpoints():
        if mount_point.path == "/":
            assert mount_point.filesystem == "ext4"
            return
    else:
        raise AssertionError("tmproot not mounted")
