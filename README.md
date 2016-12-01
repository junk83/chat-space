# users table
|column|type|not_null|key|
|:--|:--|:--|:--|
|name|string|yes||
|email|string|yes|unique|
|encrypted_password|string|yes|　|

### index
index_users_on_name

### relation
has_many :messages
has_many :group_users
has_many :groups, through: :group_users


# messages table
|column|type|not_null|key|
|:--|:--|:--|:--|
|body|text|||
|image|string|||
|user_id|integer|yes|ForeignKey|
|group_id|integer|yes|ForeignKey|


### index
index_messages_on_group_id
index_messages_on_group_id_and_user_id

### relation
belongs_to :user
belongs_to :group


# groups table
|column|type|not_null|key|
|:--|:--|:--|:--|
|name|string|yes|　|

### relation
has_many :group_users
has_many :users, through: :group_users


# group_users
|column|type|not_null|key|
|:--|:--|:--|:--|
|group_id|integer|yes|ForeignKey|
|user_id|integer|yes|ForeignKey|


### relation
belongs_to :group
belongs_to :user
