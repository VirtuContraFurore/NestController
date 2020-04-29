# Idee sulla struttura

## Widget
```C
// widget.h
struct widget{
    int x;
    int y;
    int w;
    int h;
    bool visible; //if false the widget will not be drawn and can't be touched
    struct widget_func* funcs;
    void* widget_data;
};

struct widget_func{
    /**
     * Draw the widget on screen
     */
    void (*draw)(struct widget *self);

    /**
     * Handle touch on the widget at RELATIVE coordinates (x,y)
     */
    bool (*on_touch)(struct widget *self, touch_event type, void * event_data);

    /**
     * Check if given absolute point (x,y) is within widget boundaries
     */ 
    bool (*check_boundaries)(struct widget *self, int x, int y);
};
```
Touch Events

```C
//events.h

enum touch_event {SINGLE_TOUCH, MULTI_TOUCH, DRAG_TOUCH};

enum touch_type {TOUCH_DOWN, TOUCH_UP};

/**
 * All coordinates are relative to the widget's up-left corner (0,0)
 */

struct single_touch_data {
	int x;
	int y;
	touch_type type;
};

struct multi_touch_data {
	int count;
	single_touch_data * touches;
};

struct drag_touch_data {
	int start_x;
	int start_y;
	int end_x;
	int end_y;
};

```

For each widget type (e.g. roller):

```C
// roller.h

struct roller_widget_data{
    bool vertical;
    double min;
    double max;
    double value;
    void (*value_changed_callback)(int new_value);
};

void roller_draw(struct widget *self);
void roller_on_touch(struct widget *self, touc;
void roller_check_boundaries(struct widget *self, touch_event type, void * event_data);

struct widget_func roller_widget_func = {
    .draw = &roller_draw,
    .on_touch = &roller_on_touch,
    .check_bounaries = &check_boundaries
};
```

```C
// roller.c
void roller_draw(struct widget *self){
    // TODO
}

void roller_on_touch(struct widget *self, touch_event type, void * event_data){
    // TODO
    if(type == DRAG_TOUCH){
	int newval = complex_algorithm(event_data);
	if(newval != self->value){
    		if(self->value_changed_callback != 0 ) //check if the callback is provided for this widget instance
			*(self->value_changed_callback))(newval);
		self->value = newval;
	}
    }
}

void roller_check_boundaries(struct widget *self, int x, int y){
    // TODO
}
```
Codice da generare con Acceleo:

```C
// widget_config.h

// index of the widget in the array (?)
#define M_ROLLER 0

struct roller_widget_data mRoller_data = {
    .vertical = false,
    .min = 0,
    .max = 90,
    .value = 45,
    .value_changed_callback = &user_defined_callback_for_mRoller
};

struct widget mRoller = {
    .x = 10,
    .y = 10,
    .w = 100,
    .h = 100,
    .visible = true,
    .funcs = &roller_widget_func,
    .data = (void*) &mRoller_data
};

//main.c
struct widget widgets[] = {mRoller};
```

## Eventi 
### Versione con lista
modifica a widget.h

```C
// widget.h
struct widget{
    // ...
    char event_bitmask;
    struct widget* next_event;
};
```
gestione eventi

```C
// events.h

struct widget* pending_events = NULL;

// TODO handle concurrency
void set_event(struct widget* m_widget, char bitmask){
    if (m_widget->event_bitmask){
        m_widget->event_bitmask |= bitmask;
    } else {
        m_widget->next_event = pending_events;
        pending_events = m_widget;
    }
}

void pop_event(){
    struct widget* m_widget = pending_event;
    if (m_widget){
        pending_event = m_widget->next_event;
    }
    return m_widget;
}
```

### Versione con solo bitmasks
Ogni widget può avere associati alcuni bit di evento

modifica a widget.h

```C
//widget.h

struct widget {
	...
	unsigned int bit_offset; //assegnato da Acceleo a tempo di generazione, diverso per ogni widget
} 
```
Gli eventi sono tutti nell'array events_bitmask

```C
//events.h

//total_events è assegnato da Acceleo

#define COUNT total_events/32

unsigned int events_bitmask[COUNT];

/*
* Should be called only by widget's C implementation and not by user
*/
void set_event(struct widget * m_widget, unsigned int event_number){
	int index = m_widget->bit_offset / 32;
	int relative_offset = m_widget->bit_offset - index * 32;
	events_bitmask[index] |= 1 << (event_number + relative_offset)
}

void clear_event(struct widget * m_widget, unsigned int event_number){
	int index = m_widget->bit_offset / 32;
	int relative_offset = m_widget->bit_offset - index * 32;
	events_bitmask[index] &= ~( 1 << (event_number + relative_offset) )
}

int get_event(struct widget * m_widget, unsigned int event_number){
	int index = m_widget->bit_offset / 32;
	int relative_offset = m_widget->bit_offset - index * 32;
	return (events_bitmask[index] | (1 << (event_number + relative_offset))) != 0;
}

```
