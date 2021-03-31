## Macro: get-apires-name-dup

Get all API resources with names duplicated.

<!-- tabs:start -->

### **Description**


Get all API resources with names duplicated



### **Usage & Options**

**Usage**

kubectl macro get-apires-name-dup [options]

**Options**

```

```

### **Examples**

```shell

```

### **Dependencies**

* sort
* head
* awk
* uniq
* grep

### **Installation**

To install this macro:
```shell
$ kubectl macro install get-apires-name-dup
```

Alternaltively, you can install it manually by downloading it [here](../bin/get-apires-name-dup.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/get-apires-name-dup.sh ':include :type=code shell')

<!-- tabs:end -->
