#!/bin/bash

exec &> >(tee -a /tmp/load_image.log)

while getopts ":p:r:c:" arg; do
    case "${arg}" in
      p)
        package_location=${OPTARG}
        ;;
      r)
        registry=${OPTARG}
        ;;
      u)
        regusername=${OPTARG}
        ;;
      p)
        regpassword=${OPTARG}
        ;;
    esac
done

if [ -n "${registry}" -a -n "${regusername}" -a -n "${regpassword}" ]; then
  # docker login external registry as icpdeploy
  sudo -u icpdeploy docker login -u ${regusername} -p ${regpassword} ${registry}
fi

if [ -z "${package_location}" ]; then
  # no image file, do nothing
  exit 0
fi

sourcedir="/tmp/icpimages"
# Get package from remote location if needed
if [[ "${package_location:0:4}" == "http" ]]; then

  # Extract filename from URL if possible
  if [[ "${package_location: -2}" == "gz" ]]; then
    # Assume a sensible filename can be extracted from URL
    filename=$(basename ${package_location})
  else
    # TODO We'll need to attempt some magic to extract the filename
    echo "Not able to determine filename from URL ${package_location}" >&2
    exit 1
  fi

  # Download the file using auth if provided
  echo "Downloading ${image_url}" >&2
  mkdir -p ${sourcedir}
  wget --continue ${username:+--user} ${username} ${password:+--password} ${password} \
   -O ${sourcedir}/${filename} "${image_url}"

  # Set the image file name if we're on the same platform
  if [[ ${filename} =~ .*$(uname -m).* ]]; then
    echo "Setting image_file to ${sourcedir}/${filename}"
    image_file="${sourcedir}/${filename}"
  fi
elif [[ "${package_location:0:3}" == "nfs" ]]; then
  # Separate out the filename and path
  sourcedir="/opt/ibm/cluster/images"
  nfs_mount=$(dirname ${package_location:4})
  image_file="${sourcedir}/$(basename ${package_location})"
  sudo mkdir -p ${sourcedir}

  # Mount
  sudo mount.nfs $nfs_mount $sourcedir
  if [ $? -ne 0 ]; then
    echo "An error occurred mounting the NFS server. Mount point: $nfs_mount"
    exit 1
  fi
elif [[ "${package_location:0:2}" == "gs" ]]; then
  # Separate out the filename and path
  filename=`basename ${package_location}`

  # copy it down
  gsutil cp ${package_location} /tmp/${filename}

  if [ $? -ne 0 ]; then
    echo "An error occurred pulling the binaries. package_location: ${package_location}"
    exit 1
  fi

  sourcedir="/opt/ibm/cluster/images"
  sudo mkdir -p ${sourcedir}
  image_file="${sourcedir}/${filename}"
  sudo mv /tmp/${filename} ${image_file}

else
  # This must be uploaded from local file, terraform should have copied it to /tmp
  image_file="/tmp/$(basename ${package_location})"
fi

echo "Unpacking ${image_file} ..."
pv --interval 10 ${image_file} | tar zxf - -O | sudo docker load
