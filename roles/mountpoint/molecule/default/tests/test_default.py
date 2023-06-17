"""Role testing files using testinfra."""


def test_mountpoint(host):
    """Validate /etc/hosts file."""

    assert host.run("mountpoint /var").rc == 0
