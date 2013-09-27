require 'test/unit'
require 'fileutils'
require 'zip'

Dir.chdir File.join(File.dirname(__FILE__))
$VERBOSE = true

# test zip64 support for real, by actually exceeding the 32-bit size/offset limits
# this test does not, of course, run with the normal unit tests! ;)

class Zip64FullTest < Test::Unit::TestCase
  def prepareTestFile(test_filename)
    File.delete(test_filename) if File.exists?(test_filename)
    return test_filename
  end

  def test_largeZipFile
    first_text = 'starting out small'
    last_text = 'this tests files starting after 4GB in the archive'
    test_filename = prepareTestFile('huge.zip')
    Zip::OutputStream.open(test_filename) do |io|
      io.put_next_entry('first_file.txt')
      io.write(first_text)

      # write just over 4GB (stored, so the zip file exceeds 4GB)
      buf = 'blah' * 16384
      io.put_next_entry('huge_file', nil, nil, Zip::Entry::STORED)
      65537.times { io.write(buf) }

      io.put_next_entry('last_file.txt')
      io.write(last_text)
    end

    Zip::File.open(test_filename) do |zf|
      assert_equal %w(first_file.txt huge_file last_file.txt), zf.entries.map(&:name)
      assert_equal first_text, zf.read('first_file.txt')
      assert_equal last_text, zf.read('last_file.txt')
    end

    # it might be nice to do a system("zip -T #{test_filename}")
    # except we can't guarantee the user has a version that supports zip64
    # (the version that ships with recent OS X releases doesn't!)
  end

end
