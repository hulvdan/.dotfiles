import json
import subprocess
from typing import TypedDict, Optional


class YabaiWindowManager:
	YabaiWindow = TypedDict(
		"YabaiWindow",
		{
			"id": int,
			"space": int,
			"has-focus": bool,
			"app": str,
			"title": str,
			"role": str,
			"subrole": str,
		},
	)

	def display_focused_window_info(self) -> None:
		focused_window = self._get_focused_window()
		if focused_window is None:
			return

		self._display_window_info(focused_window)

	@classmethod
	def _display_window_info(cls, window: YabaiWindow) -> None:
		cls._display_notification(
			title="Window Spy",
			message="\n".join(
				(
					f'app={window["app"]}',
					f'title={window["title"]}',
					f'role={window["role"]}',
					f'subrole={window["subrole"]}',
				),
			),
		)

	@classmethod
	def _get_focused_window(cls) -> Optional[YabaiWindow]:
		for retrieved_window in cls._get_windows():
			if retrieved_window["has-focus"]:
				return retrieved_window

		return None

	@classmethod
	def _get_windows(cls) -> list[YabaiWindow]:
		process = subprocess.run(["yabai", "-m", "query", "--windows"], capture_output=True)
		if process.returncode != 0:
			raise ValueError("TODO!")

		return json.loads(process.stdout)

	@classmethod
	def _display_notification(cls, *, title: str, message: str) -> None:
		process = subprocess.run(
			[
				"osascript",
				"-e",
				f'display notification "{message}" with title "{title}"',
			],
		)
		if process.returncode != 0:
			raise ValueError("TODO!")


def main() -> None:
	YabaiWindowManager().display_focused_window_info()


if __name__ == '__main__':
	main()
