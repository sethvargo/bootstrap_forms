Bootstrap Forms
===============
Bootstrap Forms is a nice Rails generator that makes working with [Bootstrap (by Twitter)](http://twitter.github.com/bootstrap) even easier on Rails. 

Forms with Bootstrap are crowded with additional layout markup. While it's necessary, you shouldn't have to type it every time you create a form! That's why I created Bootstrap Forms.

Bootstrap 2.0 Compliant!
------------------------
A super special thanks to [vincenzor](https://github.com/vincenzor) for updating `bootstrap_forms` to comply with the new methods and features in Twitter Bootstrap 2.0. 

To get these new features, ensure you are using `bootstrap_forms ~> 1.0.0`.

Note/Caution/Warning
--------------------
There were **major** changes in the release of version `0.1.0`:

 1. The gem name has officially changed from `bootstrap-forms` to `bootstrap_forms` to match gem naming conventions. The old gem still exists on rubygems for legacy applications, however, you should update to the new gem as quickly as possible. It's faster and more stable. The old gem is no longer maintained.
 2. `form_for` is no longer overridden by default. There were multiple users who were concerned that this behavior was ill advised. Instead, a new form helper, `bootstrap_form_for` has been created. This is in line with other form building libraries.
 3. The gem is now a Rails 3 Engine. As such, **Bootstrap Forms will not work in < Rails 3.0**. The engine is automatically mounted when including the gem in your `Gemfile`.

Installation
------------
Add it to your `Gemfile`:

    gem 'bootstrap_forms'

Don't forget to run the `bundle` command. The gem will add 2 methods `bootstrap_form_for` and `bootstrap_fields_for` for use in your project. This is different from `bootstrap_forms < 0.1.0`. In previous versions, the default form builders were overridden by default. With backlash from various community members, this is no longer the default.

Be sure to restart your Rails server after installing the gem.

Why?
----
With Bootstrap, you would need the following code for a form:

```haml
/ using HAML
= form_for @model do |f|
  .clearfix
    %label MyLabel
    .input
      = f.text_area :field, :opts => {...}
```

Using Bootstrap Forms, this is **much** simpler:

```haml
/ using HAML
= bootstrap_form_for @model do |f|
  = f.text_area :field, :opts => {...}
```

The custom form builder will automatically wrap everything for you. This helps clean up your view layer significantly!

Additional Form Methods
-----------------------
Just when you thought you were done... Bootstrap Forms includes additional form helpers that make life **a lot** easier! For example, the markup required for a list of checkboxes is quite cumbersome... well, it used to be.

### collection_check_boxes
`collection_check_boxes` behaves very similarly to `collection_select`:

```haml
= f.collection_check_boxes :category_ids, Category.all, :id, :name
```

### collection_radio_buttons
See description above...

```haml
= f.collection_radio_buttons :primary_category_id, Category.all, :id, :name
```

Uneditable Input
----------------
Bootstrap Forms adds another helper method that generates the necessary markup for uneditable inputs:

```haml
= f.uneditable_input :name
```

yields:

```html
<div class="clearfix">
  <label for="organization_name">Organization Name</label>
  <div class="input">
    <span class="uneditable-input">The Variety Hour</span>
  </div>
</div>
```

Submit Tag
----------
Bootstrap Forms also adds a default actions panel when you call `f.submit`:

```haml
= f.submit
```
    
generates:

```html
<div class="actions">
  <input type="submit" value="..." class="btn primary" />
  <a href="..." class="btn">Cancel</a>
</div>
```

Pretty swell if you ask me.

Adding More Options
-------------------
You can add as many options to any form helper tag. If they are interpreted by Bootstrap Forms, they are interpreted and rendered in the output. If not, they are passed along as values to the final HTML form object.

### Available Options

<table>
  <tr>
    <th>Name</th>
    <th>Description</th>
    <th>Usage</th>
  </tr>
  <tr>
    <th>help_inline</th>
    <td>Add inline help text</td>
    <td>= f.text_field :name, :help_inline => 'help me!'</td>
  </tr>
  <tr>
    <th>help_block</th>
    <td>Add block help text (below)</td>
    <td>= f.text_field :name, :help_block => 'help me!'</td>
  </tr>
  <tr>
    <th>error</th>
    <td>Styles the field as error (red)</td>
    <td>= f.text_field :name, :error => 'This is an error!'</td>
  </tr>
  <tr>
    <th>success</th>
    <td>Styles the field as success (green)</td>
    <td>= f.text_field :name, :success => 'This checked out OK'</td>
  </tr>
  <tr>
    <th>warning</th>
    <td>Styles the field as warning (yellow)</td>
    <td>= f.text_field :name, :warning => 'Take a look at this...'</td>
  </tr>
  <tr>
    <th>prepend</th>
    <td>Adds special text to the front of the input</td>
    <td>= f.text_field :name, :prepend => '@'</td>
  </tr>
  <tr>
    <th>append</th>
    <td>Adds special text at the end of the input</td>
    <td>= f.text_field :name, :append => '@'</td>
  </tr>
</table>

Internationalization/Custom Errors
----------------------------------
As of `1.0.2`, `bootstrap_forms` supports I18n! More support is being added, but you can change the error header and cancel button like this:

```yaml
# config/locales/en.yml
en:
  bootstrap_forms:
    errors:
      header: 'Your %{model} is wrong!'
    buttons:
      cancel: 'Forget it!'
```

Obviously you can also change to a different `lang.yml` file and use the same syntax.

Contributing
------------
I'm pretty dam active on github. Fork and submit a pull request. Most of my pull requests are merged the same day. Make sure you:

 - Squash into a single commit (unless it makes sense to have multiple commits)
 - Document your changes

License
-------
Copyright (c) 2012 Seth Vargo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.