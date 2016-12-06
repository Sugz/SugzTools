from PySide import QtCore, QtGui

class MyListWidgetItem(QtGui.QListWidgetItem):
    def __init__(self, label, parent):
        super(MyListWidgetItem, self).__init__(label, parent)


class Test(QtGui.QMainWindow):
    def __init__(self):
        super(Test,self).__init__()

        self.resize(480,320)

        myQWidget = QtGui.QWidget()
        myBoxLayout = QtGui.QVBoxLayout()
        myQWidget.setLayout(myBoxLayout)
        self.setCentralWidget(myQWidget)

        self.listWidget = QtGui.QListWidget(self)

        for x in range(1, 11):
            item = QtGui.QListWidgetItem("{0}I love PyQt!".format(x), self.listWidget)
            # listItemAInstance = MyListWidgetItem("{0}I love PyQt!".format(x)), self.listWidget)

        myBoxLayout.addWidget(self.listWidgetA)
        myBoxLayout.addWidget(self.listWidgetB)



if __name__ == '__main__':
    app = QtGui.QApplication(sys.argv)
    dialog_1 = Test()
    dialog_1.show()
    sys.exit(app.exec_())