#!/usr/bin/env ruby

require 'open3'

logpath = "./logs/test#{Time.now.to_s.split(" ")*"_"}.log"

REPEAT = 3

hosts = {
  "1": "o244-21",
  "2": "o244-21,o244-24",
  "4": "o244-21,o244-24,o244-25,o244-26",
  "6": "o244-21,o244-24,o244-25,o244-26,o244-18,o244-28",
  "8": "o244-21,o244-23,o244-24,o244-25,o244-26,o244-18,o244-28,o244-29",
  "10": "o244-21,o244-23,o244-24,o244-25,o244-26,o244-18,o244-28,o244-29,o244-30,o244-31"
}

forms = {
  ijk: "./tests/random_6000_ijk.in",
  kij: "./tests/random_6000_kij.in",
  ikj: "./tests/random_6000_ikj.in"
}

# Define -host and -ppn for mpirun command.
cases = [
  {
    hosts: hosts[:"1"],
    ppn: 1,
  },
  {
    hosts: hosts[:"2"],
    ppn: 2,
  },
  {
    hosts: hosts[:"4"],
    ppn: 2,
  },
  {
    hosts: hosts[:"8"],
    ppn: 2,
  },
  {
    hosts: hosts[:"10"],
    ppn: 2,
  }
]

logfile = File.new(logpath, 'a')

# Run each case for every loop form and REPEAT times.
cases.each do |tc|
  logfile.puts "#{tc[:hosts].split(",").length * tc[:ppn]} cores"
  forms.each do |key, value|
    logfile.puts "#{key} form"
    REPEAT.times do |i|
      logfile.puts "Run #{i+1}"
      stdout, stderr, status = Open3.capture3("mpirun -hosts #{tc[:hosts]} -ppn #{tc[:ppn]} ./matrixmult < #{value}")
      logfile.puts stdout
      logfile.puts "stderr: #{stderr} status: #{status}"
    end
  end
end
