<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">

  <p>
    Copyright © 2009 Jarno Elovirta

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see &lt;http://www.gnu.org/licenses/>.
  </p>

  <p>
    Version 2.1.0. released 2009-05-08.
  </p>
  
  <ns uri="http://dita.oasis-open.org/architecture/2005/" prefix="ditaarch"/>

  <!-- Phases -->

  <phase id="specificationMandates">
    <active pattern="otherrole"/>
    <active pattern="othernote"/>
    <active pattern="indextermref"/>
    <active pattern="collection-type_on_rel"/>
    <active pattern="keyref_attr"/>
  </phase>

  <phase id="recommendations">
    <active pattern="otherrole"/>
    <active pattern="othernote"/>
    <active pattern="indextermref"/>
    <active pattern="collection-type_on_rel"/>
    <active pattern="keyref_attr"/>
    
    <active pattern="role_attr_sample"/>
    <active pattern="role_attr_external"/>
    <active pattern="self_nested_xref"/>
    <active pattern="boolean"/>
    <active pattern="image_alt_attr"/>
    <active pattern="query_attr"/>
    <active pattern="single_paragraph"/>
    <active pattern="image_in_pre"/>
    <active pattern="object_in_pre"/>
    <active pattern="sup_in_pre"/>
    <active pattern="sub_in_pre"/>
    
    <active pattern="navtitle"/>
  </phase>

  <phase id="authoringRecommendations">
    <active pattern="xref_in_title"/>
    <active pattern="idless_title"/>
    <active pattern="required-cleanup"/>
    <active pattern="spec_attrs"/>
    <active pattern="no_topic_nesting"/>
  </phase>

  <!-- Abstract patterns -->

  <pattern abstract="true" id="self_nested_element">
    <rule context="$element">
      <report test="descendant::$element">
        The <name/> contains a <name/>. The results in processing are undefined.
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="nested_element">
    <rule context="$element">
      <report test="descendant::$descendant">
        The <name/> contains <name path="descendant::$descendant"/>.
        Using <name path="descendant::$descendant"/> in this context is ill-adviced.
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
      <report test="@*[name() = $attribute]">
        The <value-of select="$attribute"/> attribute on <name/> is reserved for future use. <value-of select="$reason"/>
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
      <report test="@*[name() = $attribute]">
        The <value-of select="$attribute"/> attribute is deprecated. <value-of select="$reason"/>
      </report>
    </rule>
  </pattern>

  <pattern abstract="true" id="deprecated_attribute_value">
    <rule context="$context">
      <report test="@*[name() = $attribute and . = $value]">
        The value "<value-of select="$value"/>" for <value-of select="$attribute"/> attribute is deprecated. <value-of select="$reason"/>
      </report>
    </rule>
  </pattern>


  <!-- Required per spec -->

  <pattern id="otherrole">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/theroleattribute.html</p>
    <rule context="*[@role = 'other']">
      <assert test="@otherrole">
        <name/> with role 'other' should have attribute 'otherrole' set. </assert>
    </rule>
  </pattern>

  <pattern id="othernote">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/thetypeattribute.html</p>
    <rule context="*[contains(@class,' topic/note ')][@type = 'other']">
      <assert test="@othertype">
        <name/> with type 'other' should have attribute 'othertype' set. </assert>
    </rule>
  </pattern>

  <pattern is-a="future_use_element" id="indextermref">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/indextermref.html</p>
    <param name="context" value="*"/>
    <param name="element" value="*[contains(@class, ' topic/indextermref ')]"/>
    <param name="reason" value="''"/>
  </pattern>

  <pattern is-a="future_use_attribute" id="collection-type_on_rel">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/topicref-atts.html</p>
    <param name="context" value="*[contains(@class, ' map/reltable ')]
                               | *[contains(@class, ' map/relcolspec ')]"/>
    <param name="attribute" value="'collection-type'"/>
    <param name="reason" value="''"/>
  </pattern>
  
  <pattern id="keyref_attr">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/othercommon.html</p>
    <rule context="*[ancestor-or-self::*/@ditaarch:DITAArchVersion &lt;= 1.1]">
      <report test="@keyref">
        The keyref attribute on <name/> is reserved for future use. XXX
      </report>
    </rule>
  </pattern>
  
  <!-- Recommended per spec -->

  <pattern is-a="deprecated_element" id="boolean">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/boolean.html</p>
    <param name="context" value="*"/>
    <param name="element" value="*[contains(@class, ' topic/boolean ')]"/>
    <param name="reason" value="'The state element should be used instead with value attribute of &quot;yes&quot; or &quot;no&quot;.'"
    />
  </pattern>

  <pattern is-a="deprecated_attribute" id="image_alt_attr">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/image.html</p>
    <param name="context" value="*[contains(@class, ' topic/image ')]"/>
    <param name="attribute" value="'alt'"/>
    <param name="reason" value="'The alt element should be used instead.'"/>
  </pattern>

  <pattern is-a="deprecated_attribute" id="query_attr">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/link.html</p>
    <param name="context" value="*[contains(@class, ' topic/link ')] |
                                 *[contains(@class, ' map/topicref ')]"/>
    <param name="attribute" value="'query'"/>
    <param name="reason" value="'It may be removed in the future.'"/>
  </pattern>

  <pattern is-a="deprecated_attribute_value" id="role_attr_sample">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/theroleattribute.html</p>
    <param name="context" value="*[contains(@class, ' topic/related-links ')] |
                                 *[contains(@class, ' topic/link ')] |
                                 *[contains(@class, ' topic/linklist ')] |
                                 *[contains(@class, ' topic/linkpool ')]"/>
    <param name="attribute" value="'role'"/>
    <param name="value" value="'sample'"/>
    <param name="reason" value="''"/>
  </pattern>

  <pattern is-a="deprecated_attribute_value" id="role_attr_external">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/common/theroleattribute.html</p>
    <param name="context" value="*[contains(@class, ' topic/related-links ')] |
                                 *[contains(@class, ' topic/link ')] |
                                 *[contains(@class, ' topic/linklist ')] |
                                 *[contains(@class, ' topic/linkpool ')]"/>
    <param name="attribute" value="'role'"/>
    <param name="value" value="'external'"/>
    <param name="reason" value="'Use the scope=&quot;external&quot; attribute to indicate external links.'"/>
  </pattern>

  <pattern id="single_paragraph">
    <p>source: http://docs.oasis-open.org/dita/v1.1/OS/langspec/langref/shortdesc.html</p>
    <rule context="*[contains(@class, ' topic/topic ')]"
          subject="*[contains(@class, ' topic/body ')]/*[contains(@class, ' topic/p ')]">
      <report test="not(*[contains(@class, ' topic/shortdesc ')] | *[contains(@class, ' topic/abstract ')]) and
                    count(*[contains(@class, ' topic/body ')]/*) = 1 and
                    *[contains(@class, ' topic/body ')]/*[contains(@class, ' topic/p ')]">
        In cases where a topic contains only one paragraph, then it is preferable to include this
        text in the shortdesc element and leave the topic body empty.
      </report>
    </rule>
  </pattern>
  
  <pattern is-a="deprecated_attribute" id="navtitle">
    <!--TODO: add source-->
    <param name="context" value="*[contains(@class, ' map/topicref ')]"/>
    <param name="attribute" value="'navtitle'"/>
    <param name="reason" value="'Preferred way to specify navigation title is navtitle element.'"/>
  </pattern>
  
  <!-- Recommended per convention -->

  <pattern is-a="self_nested_element" id="self_nested_xref">
    <p>source: http://www.w3.org/TR/html/#prohibitions</p>
    <param name="element" value="*[contains(@class, ' topic/xref ')]"/>
  </pattern>

  <pattern is-a="nested_element" id="image_in_pre">
    <p>source: http://www.w3.org/TR/html/#prohibitions</p>
    <param name="element" value="*[contains(@class, ' topic/pre ')]"/>
    <param name="descendant" value="*[contains(@class, ' topic/image ')]"/>
  </pattern>

  <pattern is-a="nested_element" id="object_in_pre">
    <p>source: http://www.w3.org/TR/html/#prohibitions</p>
    <param name="element" value="*[contains(@class, ' topic/pre ')]"/>
    <param name="descendant" value="*[contains(@class, ' topic/object ')]"/>
  </pattern>

  <pattern is-a="nested_element" id="sup_in_pre">
    <p>source: http://www.w3.org/TR/html/#prohibitions</p>
    <param name="element" value="*[contains(@class, ' topic/pre ')]"/>
    <param name="descendant" value="*[contains(@class, ' hi-d/sup  ')]"/>
  </pattern>

  <pattern is-a="nested_element" id="sub_in_pre">
    <p>source: http://www.w3.org/TR/html/#prohibitions</p>
    <param name="element" value="*[contains(@class, ' topic/pre ')]"/>
    <param name="descendant" value="*[contains(@class, ' hi-d/sub  ')]"/>
  </pattern>  

  <!-- Authoring -->

  <pattern id="xref_in_title">
    <rule context="*[contains(@class, ' topic/title ')]">
      <report test="descendant::*[contains(@class, ' topic/xref ')]" diagnostics="title_links">
        The <name/> contains <name path="descendant::*[contains(@class, ' topic/xref ')]"/>.
      </report>
    </rule>
  </pattern>

  <pattern id="idless_title">
    <rule context="*[not(@id)]">
      <report test="*[contains(@class, ' topic/title ')]" role="info" diagnostics="link_target">
        <name/> with a title should have an id attribute.
      </report>
    </rule>
  </pattern>

  <pattern id="required-cleanup">
    <rule context="*">
      <report test="*[contains(@class, ' topic/required-cleanup ')]" role="warn">
        A required-cleanup element is used as a placeholder for migrated elements and should not be used in documents by authors.
      </report>
    </rule>
  </pattern>

  <pattern id="spec_attrs">
    <rule context="@spectitle | specentry">
      <report test="." role="warn">
        <name/> attribute is not intended for direct use by authors.
      </report>
    </rule>
  </pattern>

  <pattern id="no_topic_nesting">
    <rule context="no-topic-nesting">
      <report test="." role="warn">
        <name/> element is not intended for direct use by authors, and has no associated output
        processing. </report>
    </rule>
  </pattern>

  <diagnostics>
    <diagnostic id="link_target">
      Elements with titles are candidate targets for elements level links.
    </diagnostic>
    <diagnostic id="title_links">
      Using <value-of select="name(descendant::*[contains(@class, ' topic/xref ')])"/> in this context is ill-adviced
      because titles in themselves are often used as links, e.g., in table of contents and cross-references.
    </diagnostic>
  </diagnostics>

</schema>
