/*=============================================================================

  IMAGECAPTURE: A software package for capturing images from input devices and rendering to vide outputs.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/
#include <QGuiApplication>
#include <QtQuick/QQuickView>
#include "ImageCaptureConfigure.h"
#include "captureTriangleModel.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  app.setOrganizationName("UCL");
  app.setApplicationName("QMLDemo");
  app.setApplicationVersion(QString(IMAGECAPTURE_VERSION_STRING));

  qmlRegisterType<capture::TriangleModel>("OpenGLUnderQML", 1, 0, "TriangleModel");

  QSurfaceFormat fmt;
  fmt.setDepthBufferSize(24);
  fmt.setVersion(3, 2);
  fmt.setProfile(QSurfaceFormat::CoreProfile);
  QSurfaceFormat::setDefaultFormat(fmt);

  QQuickView view;
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setSource(QUrl("qrc:/main.qml"));
  view.show();

  return app.exec();

}

