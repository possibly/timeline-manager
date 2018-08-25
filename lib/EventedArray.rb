class EventedArray < Array
  # The calling context knows whether an element has been
  # created, deleted or updated.
  # This class is to be used in an append-only environment.

  def initialize(post_delete, post_create, post_update)
    @post_delete = post_delete
    @post_create = post_create
    @post_update = post_update
  end

  def delete(data)
    @post_destroy.call(data)
  end

  def create(data)
    self << data
    @post_create.call(data)
  end

  def update(data)
    self << data
    @post_update.call(data)
  end
end
