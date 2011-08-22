<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:e="http://github.com/jelovirt/dita-schematron"
        defaultPhase="mandatory">
  
  <ns uri="http://dita.oasis-open.org/architecture/2005/" prefix="ditaarch"/>

  <!-- Abstract patterns -->

  <pattern abstract="true" id="self_nested_element">
    <rule context="$element">
      <report test="descendant::$element" role="warning">
        The <name/> element contains <name/> element. The results in processing are undefined.
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="nested_element">
    <rule context="$element">
      <report test="descendant::$descendant">
        The <name/> element contains <value-of select="name(descendant::$descendant)"/> element.
        Using <value-of select="name(descendant::$descendant)"/> in this context is ill-adviced.
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="future_use_element">
    <rule context="$context">
      <report test="$element">
        The <value-of select="name($element)"/> element is reserved for future use. <value-of select="$reason"/>
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="future_use_attribute">
    <rule context="$context">
      <report test="$attribute">
        The <value-of select="name($attribute)"/> attribute on <name/> is reserved for future use. <value-of select="$reason"/>
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="deprecated_element">
    <rule context="$context">
      <report test="$element">
        The <value-of select="name($element)"/> element is deprecated. <value-of select="$reason"/>
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="deprecated_attribute">
    <rule context="$context">
      <report test="$attribute">
        The <value-of select="name($attribute)"/> attribute is deprecated. <value-of select="$reason"/>
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="deprecated_attribute_value">
    <rule context="$context">
      <report test="$attribute[. = $value]">
        The value "<value-of select="$value"/>" for <value-of select="name($attribute)"/> attribute is deprecated. <value-of select="$reason"/>
      </report>
    </rule>
  </pattern>


  <!-- Required per spec -->

  <pattern id="otherrole" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/theroleattribute.html"
           e:phases="mandatory recommendation">
    <rule context="*[@role = 'other']">
      <assert test="@otherrole" role="error">
        The <name/> element with role attribute value 'other' should have otherrole attribute set. </assert>
    </rule>
  </pattern>

  <pattern id="othernote" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/thetypeattribute.html"
           e:phases="mandatory recommendation">
    <rule context="*[contains(@class,' topic/note ')][@type = 'other']">
      <assert test="@othertype" role="error">
        The <name/> element with type attribute value 'other' should have othertype attribute set. </assert>
    </rule>
  </pattern>

  <pattern id="indextermref" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/indextermref.html"
           e:phases="mandatory recommendation">
    <rule context="*">
      <report test="*[contains(@class, ' topic/indextermref ')]" role="error">
        The <value-of select="name(*[contains(@class, ' topic/indextermref ')])"/> element is reserved for future use. 
      </report>
    </rule>
  </pattern>

  <pattern id="collection-type_on_rel" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/topicref-atts.html"
           e:phases="mandatory recommendation">
    <rule context="*[contains(@class, ' map/reltable ')] 
                 | *[contains(@class, ' map/relcolspec ')]">
      <report test="@collection-type" role="error">
        The collection-type attribute on <name/> is reserved for future use. 
      </report>
    </rule>
  </pattern>
  
  <pattern id="keyref_attr" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/othercommon.html"
           e:ditaVersions="1.0 1.1"
           e:phases="mandatory recommendation">
    <rule context="*">
      <report test="@keyref" role="error">
        The keyref attribute on <name/> is reserved for future use.
      </report>
    </rule>
  </pattern>
  
  <!-- Recommended per spec -->

  <pattern id="boolean" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/boolean.html"
           e:phases="recommendation other">
    <rule context="*">
      <report test="*[contains(@class, ' topic/boolean ')]" diagnostics="state_element" role="warning">
        The <value-of select="name(*[contains(@class, ' topic/boolean ')])"/> element is deprecated.
      </report>
    </rule>
  </pattern>  

  <pattern id="image_alt_attr" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/image.html"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/image ')]">
      <report test="@alt" diagnostics="alt_element" role="warning">
        The alt attribute is deprecated.
      </report>
    </rule>
  </pattern>
  
  <pattern id="image_longdescref_attr" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/image.html"
    e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/image ')]">
      <report test="@longdescref" diagnostics="longdescref_element" role="warning">
        The longdescref attribute is deprecated.
      </report>
    </rule>
  </pattern>
   

  <pattern id="query_attr" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/link.html"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/link ')]
                 | *[contains(@class, ' map/topicref ')]">
      <report test="@query" role="warning">
        The query attribute is deprecated. It may be removed in the future.
      </report>
    </rule>
  </pattern>
  
  <pattern id="role_attr_value" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/theroleattribute.html"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/related-links ')]
                 | *[contains(@class, ' topic/link ')]
                 | *[contains(@class, ' topic/linklist ')]
                 | *[contains(@class, ' topic/linkpool ')]">
      <report test="@role[. = 'sample']" role="warning">
        The value "sample" for role attribute is deprecated. 
      </report>
      <report test="@role[. = 'external']" diagnostics="external_scope_attribute" role="warning">
        The value "external" for role attribute is deprecated.
      </report>
    </rule>
  </pattern>

  <pattern id="single_paragraph" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/shortdesc.html"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/topic ')]"
          subject="*[contains(@class, ' topic/body ')]/*[contains(@class, ' topic/p ')]">
      <report test="not(*[contains(@class, ' topic/shortdesc ')] | *[contains(@class, ' topic/abstract ')]) and
                    count(*[contains(@class, ' topic/body ')]/*) = 1 and
                    *[contains(@class, ' topic/body ')]/*[contains(@class, ' topic/p ')]" role="warning">
        In cases where a topic contains only one paragraph, then it is preferable to include this
        text in the shortdesc element and leave the topic body empty.
      </report>
    </rule>
  </pattern>
  
  <pattern id="shortdesc_length" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/shortdesc.html"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/shortdesc ')]">
      <let name="text" value="normalize-space(.)"/>
      <!-- This is a rudimentary guess that could be improved --> 
      <report test="string-length($text) - string-length(translate($text, ' ', '')) >= 50" role="warning">
        The short description should be a single, concise paragraph containing one or two sentences of no more than 50 words.
      </report>
    </rule>
  </pattern>
  
  <pattern id="navtitle"
           e:ditaVersions="1.2"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' map/topicref ')]">
      <report test="@navtitle" diagnostics="navtitle_element" role="warning">
        The navtitle attribute is deprecated.
      </report>
    </rule>    
  </pattern>
  
  <pattern id="map_title_attribute"
           e:ditaVersions="1.1 1.2"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' map/map ')]">
      <report test="@title" role="warning">
        Map can include a title element, which is preferred over the title attribute.
      </report>
    </rule>
  </pattern>
  
  <pattern id="topichead_navtitle"
           e:ditaVersions="1.1 1.2"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' mapgroup-d/topichead ')]">
      <assert test="@navtitle" role="warning" e:ditaVersions="1.1">
        The <name/> element should have a navtitle attrbute.
      </assert>
      <assert test="@navtitle | *[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]" role="warning" e:ditaVersions="1.2">
        The <name/> element should have a navtitle element.
      </assert>
    </rule>
  </pattern>

  <!-- Recommended per convention -->

  <pattern is-a="self_nested_element" id="self_nested_xref" see="http://www.w3.org/TR/html/#prohibitions"
           e:phases="recommendation other">
    <param name="element" value="*[contains(@class, ' topic/xref ')]"/>
  </pattern>
  
  <pattern id="pre_content" see="http://www.w3.org/TR/html/#prohibitions"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/pre ')]">
      <report test="descendant::*[contains(@class, ' topic/image ')]" role="warning">
        The <name/> contains <value-of select="name(descendant::*[contains(@class, ' topic/image ')])"/>.
        Using <value-of select="name(descendant::*[contains(@class, ' topic/image ')])"/> in this context is ill-adviced.
      </report>
      <!-- XXX: Can this actually ever happen? -->
      <report test="descendant::*[contains(@class, ' topic/object ')]" role="warning">
        The <name/> contains <value-of select="name(descendant::*[contains(@class, ' topic/object ')])"/>.
        Using <value-of select="name(descendant::*[contains(@class, ' topic/object ')])"/> in this context is ill-adviced.
      </report>
      <report test="descendant::*[contains(@class, ' hi-d/sup ')]" role="warning">
        The <name/> contains <value-of select="name(descendant::*[contains(@class, ' hi-d/sup ')])"/>.
        Using <value-of select="name(descendant::*[contains(@class, ' hi-d/sup ')])"/> in this context is ill-adviced.
      </report>
      <report test="descendant::*[contains(@class, ' hi-d/sub ')]" role="warning">
        The <name/> contains <value-of select="name(descendant::*[contains(@class, ' hi-d/sub ')])"/>.
        Using <value-of select="name(descendant::*[contains(@class, ' hi-d/sub ')])"/> in this context is ill-adviced.
      </report>
    </rule>
  </pattern>
  
  <pattern id="abstract_shortdesc"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/abstract ')]">
      <assert test="*[contains(@class, ' topic/shortdesc ')]" role="warning">
        Abstract should contain at least one shortdesc element.
      </assert>
    </rule>
  </pattern>

  <!-- Authoring -->

  <pattern id="xref_in_title"
           e:phases="author other">
    <rule context="*[contains(@class, ' topic/title ')]">
      <report test="descendant::*[contains(@class, ' topic/xref ')]" diagnostics="title_links" role="warning">
        The <name/> contains <name path="descendant::*[contains(@class, ' topic/xref ')]"/>.
      </report>
    </rule>
  </pattern>

  <!-- Deprecated -->
  <pattern id="idless_title">
    <rule context="*[not(@id)]">
      <report test="*[contains(@class, ' topic/title ')]" diagnostics="link_target" role="warning">
        The <name/> element with a title should have an id attribute.
      </report>
    </rule>
  </pattern>

  <pattern id="required-cleanup"
           e:phases="author other">
    <rule context="*">
      <report test="*[contains(@class, ' topic/required-cleanup ')]" role="warning">
        A required-cleanup element is used as a placeholder for migrated elements and should not be used in documents by authors.
      </report>
    </rule>
  </pattern>

  <pattern id="no_topic_nesting"
           e:phases="author other">
    <rule context="no-topic-nesting">
      <report test="." role="warning">
        The <name/> element is not intended for direct use by authors, and has no associated output
        processing. </report>
    </rule>
  </pattern>
  
  <pattern id="tm_character" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/tm.html"
           e:phases="author other">
    <rule context="text()">
      <report test="contains(., '™')" role="warning">
        It's preferable to use tm element instead of ™ character.
      </report>
      <report test="contains(., '℠')" role="warning">
        It's preferable to use tm element instead of ℠ character.
      </report>
      <report test="contains(., '®')" role="warning">
        It's preferable to use tm element instead of ® character.
      </report>
    </rule>
  </pattern>
  
  <pattern id="multiple_section_titles"
           e:phases="author other">
    <rule context="*[contains(@class, ' topic/section ')]">
      <report test="count(*[contains(@class, ' topic/title ')]) > 1" role="warning">
        The <name/> element should only contain one title element.
      </report>
    </rule>
  </pattern>
  
  <!-- WAI -->
  
  <pattern id="no_alt_desc" see="http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/image.html"
           e:phases="recommendation other">
    <rule context="*[contains(@class, ' topic/image ')]">
      <assert test="@alt | alt" flag="non-WAI" role="warning">
        Alternative description should be provided for users using screen readers or text-only readers.
      </assert>
    </rule>
    <rule context="*[contains(@class, ' topic/object ')]">
      <assert test="desc" flag="non-WAI" role="warning">
        Alternative description should be provided for users using screen readers or text-only readers.
      </assert>
    </rule>
  </pattern>

  <!-- Diagnostics -->

  <diagnostics>
    <diagnostic id="external_scope_attribute">
      Use the scope="external" attribute to indicate external links.
    </diagnostic>
    <diagnostic id="navtitle_element">
      Preferred way to specify navigation title is navtitle element.
    </diagnostic>
    <diagnostic id="state_element">
      The state element should be used instead with value attribute of &quot;yes&quot; or &quot;no&quot;.
    </diagnostic>
    <diagnostic id="alt_element">
      The alt element should be used instead.
    </diagnostic>
    <diagnostic id="longdescref_element">
      The longdescref element should be used instead.
    </diagnostic>
    <diagnostic id="link_target">
      Elements with titles are candidate targets for elements level links.
    </diagnostic>
    <diagnostic id="title_links">
      Using <value-of select="name(descendant::*[contains(@class, ' topic/xref ')])"/> in this context is ill-adviced
      because titles in themselves are often used as links, e.g., in table of contents and cross-references.
    </diagnostic>
  </diagnostics>

</schema>
