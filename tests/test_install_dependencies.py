from types import SimpleNamespace

from labview_fpga_hdl_tools import install_dependencies


def test_clone_repo_at_tag_prerelease_specifier_enables_prerelease(monkeypatch, tmp_path):
    allow_prerelease_values = []
    clone_commands = []

    def fake_get_all_tags(repo_url, allow_prerelease=False):
        allow_prerelease_values.append(allow_prerelease)
        return ["26.2.0.dev1", "26.2.0.dev3"]

    def fake_run(cmd, capture_output, text, check):
        clone_commands.append(cmd)
        return SimpleNamespace(stdout="", stderr="")

    monkeypatch.setattr(install_dependencies, "_get_all_tags", fake_get_all_tags)
    monkeypatch.setattr(install_dependencies.subprocess, "run", fake_run)

    result = install_dependencies._clone_repo_at_tag(
        "ni/flexrio", "~=26.2.0.dev0", tmp_path, allow_prerelease=False
    )

    assert result is True
    assert allow_prerelease_values == [True]
    assert clone_commands[0][clone_commands[0].index("--branch") + 1] == "26.2.0.dev3"


def test_clone_repo_at_tag_stable_specifier_keeps_prerelease_disabled(monkeypatch, tmp_path):
    allow_prerelease_values = []
    clone_commands = []

    def fake_get_all_tags(repo_url, allow_prerelease=False):
        allow_prerelease_values.append(allow_prerelease)
        return ["26.1.0", "26.1.1"]

    def fake_run(cmd, capture_output, text, check):
        clone_commands.append(cmd)
        return SimpleNamespace(stdout="", stderr="")

    monkeypatch.setattr(install_dependencies, "_get_all_tags", fake_get_all_tags)
    monkeypatch.setattr(install_dependencies.subprocess, "run", fake_run)

    result = install_dependencies._clone_repo_at_tag(
        "ni/flexrio", "~=26.1.0", tmp_path, allow_prerelease=False
    )

    assert result is True
    assert allow_prerelease_values == [False]
    assert clone_commands[0][clone_commands[0].index("--branch") + 1] == "26.1.1"