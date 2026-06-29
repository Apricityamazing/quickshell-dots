# quickshell-dots
## Information
Many of these widgets are based off of tonybtw's [blog post](https://www.tonybtw.com/tutorial/quickshell/), but I have made them more modular, and can be used in any sort of shell configuration, with your own configurations of course.

All of these widgets can be used independently, and most elements can be styled as seen in shell.qml.
If using these dots in full, you need to be on Hyprland. 

You will want to create keybinds for the launcher and the notifications center if you are using them with "quickshell ipc call launcher toggle" and "quickshell ipc call notifications toggle" respectively.

Network widget does not function completely yet. The NetworkWidgetBar.qml displays correctly, but I am going to make it also toggle NetworkWidget.qml itself. If you are omitting the use of NetworkWidget.qml, but decide to use NetworkWidgetBar.qml, NetworkService.qml is still required, and NetworkWidget.qml will not work without it.

To customize everything yourself, study the implementation in the different theme directories. The shell.qml file in the quickshell directory is a blank slate with no custom colors, but it does have the predefined theme colors already.
