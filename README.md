# Photo-app

* Backend <br>
This application contains 1 model `Property` with a required `name` and `has many photos`
For each property, the third photo is the property cover
The photos are stored locally.



## 1 - Versions
 Ruby:
<pre>ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux]</pre>

 Rails:
<pre>Rails 7.0.2.3
</pre>

## 2 - Model

```ruby 
class Property < ApplicationRecord
    validates :name, presence: true, length: { minimum:3 }
    has_many_attached :images, dependent: :destroy
    validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

end
```

`````````````````````````````````````````````````
