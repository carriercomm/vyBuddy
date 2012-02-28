class RemoteCommand < ActiveRecord::Base
  belongs_to :user

  has_many :task_remote_commands, :dependent => :destroy
  has_many :tasks, :through => :task_remote_commands

  validates :mode, :command, :presence => true

  validates :command, :uniqueness => {:scope => :mode}

  validates :mode,
    :inclusion  => { :in => REMOTE_COMMAND_MODES, :message => "\'%{value}\' is not a valid remote command mode" }

  scope :sorted, order(["`mode` DESC, `command` ASC"])

  def executor
    return case self.mode
      when "operational"    then "/opt/vyatta/bin/vyatta-op-cmd-wrapper"
      when "configuration"  then "/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper"
      when "system"         then ""
      else nil
    end
  end

  def full_command
    self.executor + " " + self.command
  end

end
