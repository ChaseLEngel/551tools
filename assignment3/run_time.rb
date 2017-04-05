#!/usr/bin/env ruby

pid = spawn("ruby ./time.rb")
Process.detach pid
