#/*============================================================================
#
#  IMAGECAPTURE: A software package for capturing images from input devices and rendering to vide outputs.
#
#  Copyright (c) University College London (UCL). All rights reserved.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#  See LICENSE.txt in the top level directory for details.
#
#============================================================================*/

#-----------------------------------------------------------------------------
# OpenCV
#-----------------------------------------------------------------------------
if(NOT BUILD_OpenCV)
  return()
endif()

# Sanity checks
if(DEFINED OpenCV_DIR AND NOT EXISTS ${OpenCV_DIR})
  message(FATAL_ERROR "OpenCV_DIR variable is defined but corresponds to non-existing directory")
endif()

set(version "3.3.1")
set(location "${NIFTK_EP_TARBALL_LOCATION}/opencv-3.3.1.tar.gz")
mpMacroDefineExternalProjectVariables(OpenCV ${version} ${location})
set(proj_DEPENDENCIES )
if (BUILD_VTK)
  list(APPEND proj_DEPENDENCIES VTK)
endif()

if(NOT DEFINED OpenCV_DIR)

  set(_vtk_options
    -DWITH_VTK:BOOL=${BUILD_VTK}
  )
  if(BUILD_VTK)
    list(APPEND _vtk_options
      -DVTK_DIR:PATH=${VTK_DIR}
    )
  endif()

  set(_cuda_options
    -DWITH_CUDA:BOOL=${IMAGECAPTURE_USE_CUDA}
  )
  if(IMAGECAPTURE_USE_CUDA)
    list(APPEND _cuda_options
      -DCUDA_TOOLKIT_ROOT_DIR:PATH=${CUDA_TOOLKIT_ROOT_DIR}
      -DCUDA_ARCH_BIN:STRING=${IMAGECAPTURE_CUDA_ARCH_BIN}
      -DCUDA_PROPAGATE_HOST_FLAGS:BOOL=OFF
    )
    if(CMAKE_COMPILER_IS_GNUCXX)
      list(APPEND _cuda_options -DCUDA_NVCC_FLAGS:STRING=${IMAGECAPTURE_CXX11_FLAG}^^--expt-relaxed-constexpr)
    else()
      list(APPEND _cuda_options -DCUDA_NVCC_FLAGS:STRING=${IMAGECAPTURE_CXX11_FLAG})
    endif()
  endif()

  if(CTEST_USE_LAUNCHERS)
    list(APPEND additional_cmake_args
      "-DCMAKE_PROJECT_${proj}_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake"
    )
  endif()

  ExternalProject_Add(${proj}
    LIST_SEPARATOR ^^
    PREFIX ${proj_CONFIG}
    SOURCE_DIR ${proj_SOURCE}
    BINARY_DIR ${proj_BUILD}
    INSTALL_DIR ${proj_INSTALL}
    URL ${proj_LOCATION}
    URL_MD5 ${proj_CHECKSUM}
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      ${EP_COMMON_ARGS}
      -DCMAKE_PREFIX_PATH:PATH=${IMAGECAPTURE_PREFIX_PATH}
      -DBUILD_opencv_core:BOOL=ON
      -DBUILD_opencv_calib3d:BOOL=ON
      -DBUILD_opencv_features2d:BOOL=ON
      -DBUILD_opencv_imgproc:BOOL=ON
      -DBUILD_opencv_video:BOOL=ON
      -DBUILD_opencv_python:BOOL=OFF
      -DBUILD_opencv_ts:BOOL=OFF
      -DBUILD_opencv_java:BOOL=OFF
      -DBUILD_opencv_nonfree:BOOL=${OPENCV_WITH_NONFREE}
      -DBUILD_DOCS:BOOL=OFF
      -DBUILD_DOXYGEN_DOCS:BOOL=OFF
      -DBUILD_PERF_TESTS:BOOL=OFF
      -DWITH_QT:BOOL=OFF
      -DWITH_GTK:BOOL=OFF
      -DWITH_EIGEN:BOOL=OFF
      -DWITH_WEBP:BOOL=OFF  # On Mac, with Homebrew, this is read-only which breaks packaging.
      -DWITH_FFMPEG:BOOL=${OPENCV_WITH_FFMPEG}
      -DWITH_OPENMP:BOOL=${IMAGECAPTURE_USE_OPENMP}
      ${_vtk_options}
      ${_cuda_options}
      "-DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS} ${IMAGECAPTURE_CXX11_FLAG} -DVTK_MAJOR_VERSION=6" # Doesn't matter what version, as long as > 5.
      ${additional_cmake_args}
    CMAKE_CACHE_ARGS
      ${EP_COMMON_CACHE_ARGS}
    CMAKE_CACHE_DEFAULT_ARGS
      ${EP_COMMON_CACHE_DEFAULT_ARGS}
    DEPENDS ${proj_DEPENDENCIES}
  )

  set(OpenCV_DIR ${proj_INSTALL})
  set(IMAGECAPTURE_PREFIX_PATH ${proj_INSTALL}^^${IMAGECAPTURE_PREFIX_PATH})
  mitkFunctionInstallExternalCMakeProject(${proj})

  message("SuperBuild loading OpenCV from ${OpenCV_DIR}")

else()

  mitkMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")

endif()

