# STANDARD IMPORT
from os.path import *
import sys

try:
    import MaxPlus
except ImportError:
    pass

# IMPORT PYSIDE MODULES
from PySide import QtGui

# Custom Modules
import Widgets.SgzWidgets as sgz


class DockWidget(QtGui.QWidget):
    def __init__(self):
        super(DockWidget, self).__init__()

        self.setWindowTitle("SugzTools")
        self.resize(250, 400)

        # get and setup the css setStyleSheet
        cssPath = abspath(join(dirname(__file__),
                               'StyleSheet\MainStyle.css'))
        with open(cssPath) as cssFile:
            styleData = cssFile.read()
        self.setStyleSheet(styleData)

        self.init_ui()

    def init_ui(self):
        # add a layout to the empty widget
        self.vBox = QtGui.QVBoxLayout(self)
        #
        # # first rollout
        # self.rollout = sgz.SgzRollout("Rollout", True)
        #
        # self.btn1 = QtGui.QPushButton("Button 1")
        # self.btn2 = QtGui.QPushButton("Button 2")
        #
        # self.rolloutLayout = QtGui.QVBoxLayout()
        # self.rolloutLayout.addWidget(self.btn1)
        # self.rolloutLayout.addWidget(self.btn2)
        # self.rolloutLayout.addStretch(1)
        # self.rollout.setLayout(self.rolloutLayout)
        #
        # # second rollout (empty)
        # self.rollout2 = sgz.SgzRollout("Rollout 2", True)
        #
        # self.vBox.addWidget(self.rollout)
        # self.vBox.addWidget(self.rollout2)
        # self.vBox.addStretch(1)

        # Create ListWidget and add 10 items to move around.
        self.list_widget = QtGui.QListWidget()
        self.list_widget.setMinimumSize(180, 380)
        for x in range(1, 11):
            # Create widget
            rollout = sgz.SgzRollout("Rollout {0}".format(x), True)

            btn1 = QtGui.QPushButton("Button 1""R {0} Button 1".format(x))
            btn2 = QtGui.QPushButton("Button 1""R {0} Button 2".format(x))

            rolloutLayout = QtGui.QVBoxLayout()
            rolloutLayout.addWidget(btn1)
            rolloutLayout.addWidget(btn2)
            rolloutLayout.addStretch(1)
            rollout.setLayout(rolloutLayout)

            item = QtGui.QListWidgetItem()
            item.setSizeHint(rollout.sizeHint())
            self.list_widget.addItem(item)
            self.list_widget.setItemWidget(item, rollout)

        # Enable drag & drop ordering of items.
        self.list_widget.setDragDropMode(QtGui.QAbstractItemView.InternalMove)
        self.vBox.addWidget(self.list_widget)
        self.vBox.addStretch(1)


if __name__ == '__main__':
    app = QtGui.QApplication.instance()
    if not app:
        app = QtGui.QApplication(sys.argv)
        w = DockWidget()
        w.show()
    else:
        w = DockWidget()
        MaxPlus.MakeQWidgetDockable(w, 14),  # Make dockable on Left, Right and Bottom

    try:
        sys.exit(app.exec_())
    except SystemExit:
        pass
