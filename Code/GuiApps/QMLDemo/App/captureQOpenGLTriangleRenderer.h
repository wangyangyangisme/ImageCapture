/*=============================================================================

  IMAGECAPTURE: A software package for capturing images from input devices and rendering to vide outputs.

  Copyright (c) University College London (UCL). All rights reserved.

  This software is distributed WITHOUT ANY WARRANTY; without even
  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  PURPOSE.

  See LICENSE.txt in the top level directory for details.

=============================================================================*/

#ifndef captureQOpenGLTriangleRenderer_h
#define captureQOpenGLTriangleRenderer_h

#include <QObject>
#include <QtGui/QOpenGLFunctions>
#include <QtGui/QOpenGLShaderProgram>
#include <QtGui/QOpenGLVertexArrayObject>
#include <QtGui/QOpenGLBuffer>
#include <QtQuick/QQuickWindow>

namespace capture
{

/**
 * \class QOpenGLTriangleRenderer
 * \brief Demo View class to render a TriangleModel into a QQuickWindow using OpenGL.
 */
class QOpenGLTriangleRenderer : public QObject, protected QOpenGLFunctions
{
  Q_OBJECT

public:

  QOpenGLTriangleRenderer();
  ~QOpenGLTriangleRenderer();

  void setDegrees(qreal d) { m_Degrees = d; }
  void setViewportSize(const QSize &size);
  void setWindow(QQuickWindow *window);
  void setTriangleData(QVector<float>* data);

public slots:

  void paint();

private:

  qreal                     m_Degrees;
  QSize                     m_ViewportSize;
  QQuickWindow             *m_Window;
  QOpenGLShaderProgram     *m_Program;
  QOpenGLVertexArrayObject  m_VAO;
  QOpenGLBuffer             m_VBO;
  QVector<float>           *m_TriangleData;
  bool                      m_TriangleDataDirty;
  int                       m_ProjMatrixLoc;
  int                       m_ModelViewMatrixLoc;
  QMatrix4x4                m_ProjMatrix;
  QMatrix4x4                m_ModelViewMatrix;
  QMatrix4x4                m_CameraMatrix;
};

} // end namespace

#endif
