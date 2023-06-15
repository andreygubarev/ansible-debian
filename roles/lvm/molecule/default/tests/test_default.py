"""Role testing files using testinfra."""


def test_logical_volume(host):
    """Test if logical volume exists."""
    assert host.file("/dev/mapper/vg0-lv0").exists
