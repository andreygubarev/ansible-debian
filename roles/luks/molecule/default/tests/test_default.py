"""Role testing files using testinfra."""


def test_luks_installed(host):
    """Check if luks is installed."""
    assert host.package("cryptsetup").is_installed

def test_luks_mounted(host):
    """Check if luks is mounted."""
    assert host.mount_point("/mnt/local").exists
