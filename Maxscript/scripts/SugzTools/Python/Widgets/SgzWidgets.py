# STANDARD IMPORT
from os.path import *

# IMPORT PYSIDE MODULES
from PySide import QtGui, QtCore
from PySide.QtCore import Qt


class SgzRollout(QtGui.QFrame):
    _header = ""
    _isExpanded = False

    def __init__(self, header, isExpanded):
        super(SgzRollout, self).__init__()

        self._header = "       {0}".format(header)
        self._isExpanded = isExpanded
        self.setMinimumHeight(20)
        self.init_ui()
        self.setExpandState()

    def init_ui(self):
        # The body
        self.body = QtGui.QWidget()

        # The Header Part
        self.headerBtn = QtGui.QPushButton(self._header)
        self.headerBtn.setObjectName("RolloutHeaderBtn")
        self.headerBtn.setCheckable(True)
        self.headerBtn.setChecked(self._isExpanded)
        self.headerBtn.clicked.connect(self.setExpandState)

        self.dragBtn = QtGui.QPushButton()
        self.dragBtn.setMaximumSize(22, 20)
        self.dragBtn.setObjectName("RolloutDragBtn")

        self.headerLayout = QtGui.QHBoxLayout(self)
        self.headerLayout.setContentsMargins(0, 0, 0, 0)
        self.headerLayout.addWidget(self.headerBtn)
        self.headerLayout.addWidget(self.dragBtn)

        self.header = QtGui.QFrame()
        self.header.setLayout(self.headerLayout)

        # The rollout layout
        self.mainLayout = QtGui.QVBoxLayout(self)
        self.mainLayout.setContentsMargins(0, 0, 0, 0)
        self.mainLayout.addWidget(self.header)
        self.mainLayout.addWidget(self.body)

    def setExpandState(self):
        if self._isExpanded is True:
            self.body.setVisible(True)
            # self.resize(self.width(), (self.header.height() + self.body.height()))
        else:
            self.body.setHidden(True)
            # self.resize(self.width(), self.header.height())

        self._isExpanded = not self._isExpanded

    def setLayout(self, layout):
        self.body.setLayout(layout)

