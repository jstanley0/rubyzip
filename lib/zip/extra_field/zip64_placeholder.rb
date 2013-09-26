module Zip
  # placeholder to reserve space for a Zip64 extra information record, for the
  # local file header only, that we won't know if we'll need until after
  # we write the file data
  class ExtraField::Zip64Placeholder < ExtraField::Generic
    HEADER_ID = "\x99\x99" # this ID is used by other libraries such as .NET's Ionic.zip
    register_map

    def initialize(binstr = nil)
    end

    def pack_for_local
      "\x00" * 16
    end

    def pack_for_c_dir
      ""
    end

    def ==(other)
      other.is_a?(ExtraField::Zip64Placeholder)
    end
  end
end
