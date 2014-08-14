alphabet =(0..25).inject([]) { |acc,item| acc << (item+97).chr }

system "pwd"
fromPath = "/Users/richardtolley/Desktop/Script PNG Images/Uncials/uncial_majuscules_pngs"
toPath = "/Users/richardtolley/Desktop/Script PNG Images/Uncials/uncial_miniscules_pngs"

alphabet.each do |letter|

from = fromPath + "/uncial_majuscule_#{letter}.png"
to = toPath + "/uncial_miniscule_#{letter}.png"
puts from
puts to
command = "mv #{from} #{to}"
puts command
system command

end