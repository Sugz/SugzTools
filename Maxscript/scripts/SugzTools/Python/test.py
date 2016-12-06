from os.path import *
import sys
from PySide import QtGui


class Widget(QtGui.QWidget):
    def __init__(self):
        super(Widget, self).__init__()

        self.img = QtGui.QPixmap("D:/Travail/GitHub/SugzTools/Maxscripts/OnWork/scripts/SugzTools/Python/Folder_16i.bmp")
        self.container = QtGui.QLabel()
        self.container.setPixmap(self.img)

        self.receiver = QtGui.QLabel()
        self.main = QtGui.QHBoxLayout()

        self.layoutContainer = QtGui.QVBoxLayout()
        self.layoutContainer.addWidget(self.container)

        self.layoutReceiver = QtGui.QVBoxLayout()
        self.layoutReceiver.addWidget(self.receiver)

        self.main.addLayout(self.layoutContainer)
        self.main.addLayout(self.layoutReceiver)

        self.setWindowTitle("Test")
        self.setFixedSize(400, 400)





if __name__ == '__main__':
  app = QtGui.QApplication(sys.argv)
  widget = Widget()
  widget.show()

  sys.exit(app.exec_())