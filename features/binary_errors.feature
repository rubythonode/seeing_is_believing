Feature: Running the binary unsuccessfully

  Sometimes I mess up and use the program in a way that doesn't work.
  I'd like it to be helpful in these situations so I can fix my use.

  Scenario: Raising exceptions
    Given the file "raises_exception.rb":
    """
    raise "ZOMG!"
    """
    And the file "requires_exception_raising_code.rb":
    """
    1 + 1
    require_relative 'raises_exception'
    1 + 1
    """
    When I run "seeing_is_believing requires_exception_raising_code.rb"
    Then stderr is "ZOMG!"
    And the exit status is 1
    And stdout is:
    """
    1 + 1                                # => 2
    require_relative 'raises_exception'  # ~> RuntimeError: ZOMG!
    1 + 1
    """

  Scenario: Syntactically invalid file
  Scenario: Passing a nonexistent file