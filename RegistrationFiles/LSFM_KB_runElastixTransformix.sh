
## EXPORT MOVING (LSFM IMAGE) AND FIXED (REFERENCE BRAIN) IMAGES
export FIXED_IMAGE=/data/rmunozca/KB_RMC/TemplateBrain_25micron.tif
export MOVING_IMAGE=/data/rmunozca/KB_RMC/KB_RMC_a_TiffStack.tif

## EXPORT REGISTRATION PARAMETERS
export AFFINEPARFILE=/data/rmunozca/Par0000affine.txt
export BSPLINEPARFILE=/data/rmunozca/Par0000bspline.txt

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/rmunozca/elastix_linux64_v4.6/lib/
export ELASTIX=/data/rmunozca/elastix_linux64_v4.6/bin/elastix
export ELASTIX_OUTPUT_DIR=elastixOutput_KB_a
mkdir $ELASTIX_OUTPUT_DIR

## RUN REGISTRATION WITH ELASTIX
$ELASTIX -threads 24 -m $MOVING_IMAGE -f $FIXED_IMAGE -p $AFFINEPARFILE -p $BSPLINEPARFILE -out $ELASTIX_OUTPUT_DIR

export inputImage=/data/rmunozca/KB_RMC/KB_RMC_a_TiffStack.tif
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/rmunozca/elastix_linux64_v4.6/lib/
export TRANSFORMIX=/data/rmunozca/elastix_linux64_v4.6/bin/transformix

cd elastixOutput_KB_a_sagittal*
cp TransformParameters.0.txt TransformParameters_labels.0.txt
cp TransformParameters.1.txt TransformParameters_labels.1.txt
sed -i 's/TransformParameters.0.txt/TransformParameters_labels.0.txt/g' TransformParameters_labels.1.txt
sed -i 's/FinalBSplineInterpolationOrder 3/FinalBSplineInterpolationOrder 0/g' TransformParameters_labels.1.txt
sed -i 's/(ResultImageFormat "mhd")/(ResultImageFormat "nrrd")/g' TransformParameters_labels.0.txt
sed -i 's/(ResultImageFormat "mhd")/(ResultImageFormat "nrrd")/g' TransformParameters_labels.1.txt
sed -i 's/(ResultImagePixelType "short")/(ResultImagePixelType "float")/g' TransformParameters_labels.0.txt
sed -i 's/(ResultImagePixelType "short")/(ResultImagePixelType "float")/g' TransformParameters_labels.1.txt

cd -

## SET-UP TRANSFORMIX
export PARAMETERS=`expr "$ELASTIX_OUTPUT_DIR"/TransformParameters_labels.1.txt`
export TRANSFORMIX_OUTPUT_DIR=transformixOutput_KB_a
mkdir $TRANSFORMIX_OUTPUT_DIR

## RUN TRANSFORMATION
$TRANSFORMIX -threads 16 -in $inputImage -tp $PARAMETERS -out $TRANSFORMIX_OUTPUT_DIR

