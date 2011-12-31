Bootstrap Forms
===============
Bootstrap Forms is a nice Rails generator that makes working with [Bootstrap (by Twitter)](http://twitter.github.com/bootstrap) even easier on Rails. 

Forms with Bootstrap are crowded with additional layout markup. While it's necessary, you shouldn't have to type it every time you create a form! That's why I created Bootstrap Forms.

Installation
------------
Add it to your `Gemfile`:

    gem 'bootstrap-forms'

Don't forget to run the `bundle` command. Run the generator:

    rails g bootstrap_forms:install

This will create 2 files in your project.

Restart your Rails server.

Why?
----
With Bootstrap, you would need the following code for a form:

    # using HAML
    = form_for @model do |f|
      .clearfix
        %label MyLabel
        .input
          = f.text_area :field, :opts => {...}

    # using ERB
    <%= form_for @model do |f| %>
      <div class="clearfix">
        <label>MyLabel</label>
        <div class="input">
          <%= f.text_area :field, :opts => {...} %>
        </div>
      </div>
    <% end %>

Using Bootstrap Forms, this is **much** simpler:

    # using HAML
    = form_for @model do |f|
      = f.text_area :field, :opts => {...}
    
    # using ERB
    <%= form_for @model do |f| %>
      <%= f.text_area :field, :opts => {...} %>
    <% end %>

The custom form builder will automatically wrap everything for you. This helps clean up your view layer significantly!

Additional Form Methods
-----------------------
Just when you thought you were done... Bootstrap Forms includes additional form helpers that make life **a lot** easier! For example, the markup required for a list of checkboxes is quite cumbersome... well, it used to be.

### collection_check_boxes
`collection_check_boxes` behaves very similarly to `collection_select`:

    = f.collection_check_boxes :category_ids, Category.all, :id, :name

### collection_radio_buttons
See description above...

    = f.collection_radio_buttons :primary_category_id, Category.all, :id, :name

Uneditable Field
----------------
Bootstrap Forms adds another helper method that generates the necessary markup for uneditable fields:

    = f.uneditable_field :name

generates:

    <div class="clearfix">
      <label for="organization_name">Organization Name</label>
      <div class="input">
        <span class="uneditable-input">The Variety Hour</span>
      </div>
    </div>

Submit Tag
----------
Bootstrap Forms also adds a default actions panel when you call `f.submit`:

    = f.submit
    
generates:

    <div class="actions">
      <input type="submit" value="..." class="btn primary" />
      <a href="..." class="btn">Cancel</a>
    </div>

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
    <td>`= f.text_field :name, :help_inline => 'help me!'`</td>
  </tr>
  <tr>
    <th>help_block</th>
    <td>Add block help text (below)</td>
    <td>`= f.text_field :name, :help_block => 'help me!'`</td>
  </tr>
  <tr>
    <th>error</th>
    <td>Styles the field as error (red)</td>
    <td>`= f.text_field :name, :error => 'This is an error!'`</td>
  </tr>
  <tr>
    <th>success</th>
    <td>Styles the field as success (green)</td>
    <td>`= f.text_field :name, :success => 'This checked out OK'`</td>
  </tr>
  <tr>
    <th>warning</th>
    <td>Styles the field as warning (yellow)</td>
    <td>`= f.text_field :name, :warning => 'Take a look at this...'`</td>
  </tr>
  <tr>
    <th>prepend</th>
    <td>Adds special text to the front of the input</td>
    <td>`= f.text_field :name, :prepend => '@'`</td>
  </tr>
  <tr>
    <th>append</th>
    <td>Adds special text at the end of the input</td>
    <td>`= f.text_field :name, :append => '@'`</td>
  </tr>
</table>

License
-------
Copyright (c) 2011 Seth Vargo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.