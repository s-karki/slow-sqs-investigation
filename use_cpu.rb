require "securerandom"

def simulate_busy_cpu
  puts "Simulating a busy CPU..."
  start_time = Time.now

  100000.times do |i|
    Array.new(i) do
       SecureRandom.rand
    end
  end

  end_time = Time.now
  puts "CPU simulation complete. Elapsed time: #{end_time - start_time} seconds"
end

7.times do
  pid = fork do
    puts "Forked process with PID: #{Process.pid}"
    simulate_busy_cpu
  end
end

Process.waitall
