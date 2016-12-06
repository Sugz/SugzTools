from os.path import *
import sys
from PySide import QtGui



class SgzRollout(QtGui.QListWidgetItem):
    def __init__(self, label):
        super(SgzRollout, self).__init__()

        self.label = QtGui.QLabel(label)



class Widget(QtGui.QWidget):
    def __init__(self, parent=None):
        super(Widget, self).__init__(parent)


        # get and setup the css setStyleSheet
        cssPath = abspath(join(dirname(__file__),
                               'StyleSheet\MainStyle.css'))
        with open(cssPath) as cssFile:
            styleData = cssFile.read()
        self.setStyleSheet(styleData)

        self.widget_layout = QtGui.QVBoxLayout()


        # Create ListWidget and add 10 items to move around.
        self.list_widget = QtGui.QListWidget()
        for x in range(1, 11):
            item = QtGui.QListWidgetItem("{0} I love PyQt!".format(x))
            self.list_widget.addItem(item)

        # Enable drag & drop ordering of items.
        self.list_widget.setDragDropMode(QtGui.QAbstractItemView.InternalMove)

        self.widget_layout.addWidget(self.list_widget)
        self.setLayout(self.widget_layout)


if __name__ == '__main__':
  app = QtGui.QApplication(sys.argv)
  widget = Widget()
  widget.show()

  sys.exit(app.exec_())  