require 'puppet/util/execution'

Puppet::Type.type(:vagrant_box).provide :vagrant_box do
  include Puppet::Util::Execution

  def create
    name = @resource[:name]

    cmd = [
      "/usr/bin/vagrant",
      "box",
      "add",
      name,
      @resource[:source]
    ]

    if @resource[:provider]
      cmd << "--provider"
      cmd << "#{@resource[:provider]}"
    end

    cmd << "--force" if @resource[:force]

    execute(cmd, opts) unless exists?
  end

  def destroy
    name = @resource[:name]

    cmd = [
      "/usr/bin/vagrant",
      "box",
      "remove",
      name,
    ]

    if @resource[:provider]
      cmd << "--provider"
      cmd << "#{@resource[:provider]}"
    end

    execute cmd, opts
  end

  def exists?
    if @resource[:force]
      false
    else
      dir_name = @resource[:name].split('/').join('-VAGRANTSLASH-')

      File.directory? \
        "/Users/#{Facter[:boxen_user].value}/.vagrant.d/boxes/#{dir_name}"
    end
  end

  private
  def custom_environment
    {
      "HOME"         => "/Users/#{Facter[:boxen_user].value}",
      "VAGRANT_HOME" => "/Users/#{Facter[:boxen_user].value}/.vagrant.d",
    }
  end

  def opts
    {
      :combine            => true,
      :custom_environment => custom_environment,
      :failonfail         => true,
      :uid                => Facter[:boxen_user].value,
    }
  end
end
