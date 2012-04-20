require 'pathname'

Puppet::Type.newtype(:filesystem) do

    desc "The filesystem type"

    ensurable

    newparam(:fs_type) do
        desc "The file system type. eg. ext3."
    end

    newparam(:name) do
        isnamevar
        validate do |value|
            unless Pathname.new(value).absolute?
                raise ArgumentError, "Filesystem names must be fully qualified"
            end
        end
    end

    newparam(:options) do
        desc "Params for the mkfs command. eg. -l internal,agcount=x"
    end

    autorequire(:logical_volume) do
        (vgname, lvname) = self[:name].split(/\//)[-2..-1]
        resource = catalog.resource(:logical_volume, lvname) and resource[:volume_group] = vgname
    end

end
