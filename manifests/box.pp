# Public: Manages vagrant boxes
#
# Usage:
#
#   vagrant::box { 'precise64/vmware_fusion':
#     source   => 'http://files.vagrantup.com/precise64_vmware_fusion.box'
#   }

define vagrant::box(
  $source,
  $ensure       = 'present',
  $vmprovider   = 'virtualbox'
) {
  require vagrant
  include boxen::config

  vagrant_box { $name:
    ensure       => $ensure,
    source       => $source,
    vmprovider   => $vmprovider
  }
}
