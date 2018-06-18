##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

class MetasploitModule < Msf::Post
  def initialize(info={})
    super( update_info( info,
      'Name'          => 'Multi Manage the screensaver of the target computer',
      'Description'   => %q{
        This module allows you to turn on or off the screensaver of the target computer and also
        lock the current session.
      },
      'License'       => MSF_LICENSE,
      'Author'        => [ 'Eliott Teissonniere'],
      'Platform'      => [ 'linux' ],
      'SessionTypes'  => [ 'shell', 'meterpreter' ],
      'Actions'       =>
        [
          [ 'LOCK',  { 'Description' => 'Lock the current session' } ],
          [ 'START', { 'Description' => 'Start the screensaver, may lock the current session' } ],
          [ 'STOP',  { 'Description' => 'Stop the screensaver, user may be prompted for its password' }]
        ]
    ))
  end

  def lock_session
    case session.platform
    when 'linux'
      begin
        cmd_exec('xdg-screensaver lock')
      rescue EOFError
        return false
      end
    end

    true
  end

  def start_screensaver
    case session.platform
    when 'linux'
      begin
        cmd_exec('xdg-screensaver activate')
      rescue EOFError
        return false
      end
    end

    true
  end

  def stop_screensaver
    case session.platform
    when 'linux'
      begin
        cmd_exec('xdg-screensaver reset')
      rescue EOFError
        return false
      end
    end

    true
  end

  def run
    if action.nil?
      print_error('Please specify an action')
    end

    case action.name
     when 'LOCK'
       return lock_session
     when 'START'
       return start_screensaver
     when 'STOP'
       return stop_screensaver
    end
  end
end
