#include<assert.h>
typedef  int LONG_PTR, *PLONG_PTR;
typedef unsigned int ULONG_PTR, *PULONG_PTR;
typedef void *PVOID;
#define SANITIZE_PARENT_NODE(Parent) ((PMMADDRESS_NODE)(((ULONG_PTR)(Parent)) & ~0x3))
typedef struct _MMADDRESS_NODE {
	union {
		LONG_PTR Balance : 2;
		struct _MMADDRESS_NODE *Parent;
	} u1;
	struct _MMADDRESS_NODE *LeftChild;
	struct _MMADDRESS_NODE *RightChild;
	ULONG_PTR StartingVpn;
	ULONG_PTR EndingVpn;
} MMADDRESS_NODE, *PMMADDRESS_NODE;

typedef enum _TABLE_SEARCH_RESULT{
	TableEmptyTree,
	TableFoundNode,
	TableInsertAsLeft,
	TableInsertAsRight
} TABLE_SEARCH_RESULT;



typedef struct _MM_AVL_TABLE {
	MMADDRESS_NODE  BalancedRoot;
	ULONG_PTR DepthOfTree : 5;
	ULONG_PTR Unused : 3;
	ULONG_PTR NumberGenericTableElements : 24;
	PVOID NodeHint;
	PVOID NodeFreeHint;
} MM_AVL_TABLE, *PMM_AVL_TABLE;

TABLE_SEARCH_RESULT
	MiFindNodeOrParent (
	PMM_AVL_TABLE Table,
	ULONG_PTR StartingVpn,
	PMMADDRESS_NODE *NodeOrParent
	)
{
	unsigned long NumberCompares = 0;
	PMMADDRESS_NODE Child;
	PMMADDRESS_NODE NodeToExamine;

	if (Table->NumberGenericTableElements == 0) {
		return TableEmptyTree;
	}

	NodeToExamine = (PMMADDRESS_NODE) Table->BalancedRoot.RightChild;

	do {

		//
		// Make sure the depth of tree is correct.
		//

		//  assert(++NumberCompares <= Table->DepthOfTree);

		//
		// Compare the buffer with the key in the tree element.
		//

		if (StartingVpn < NodeToExamine->StartingVpn) {

			Child = NodeToExamine->LeftChild;

			if (Child != NULL) {
				NodeToExamine = Child;
			}
			else {

				//
				// Node is not in the tree.  Set the output
				// parameter to point to what would be its
				// parent and return which child it would be.
				//

				*NodeOrParent = NodeToExamine;
				return TableInsertAsLeft;
			}
		}
		else if (StartingVpn <= NodeToExamine->EndingVpn) {

			//
			// This is the node.
			//

			*NodeOrParent = NodeToExamine;
			return TableFoundNode;
		}
		else {

			Child = NodeToExamine->RightChild;

			if (Child != NULL) {
				NodeToExamine = Child;
			}
			else {

				//
				// Node is not in the tree.  Set the output
				// parameter to point to what would be its
				// parent and return which child it would be.
				//

				*NodeOrParent = NodeToExamine;
				return TableInsertAsRight;
			}
		}

	} while (1);
}



#define rb_black 0
#define rb_red 1

PMMADDRESS_NODE rb_parent(PMMADDRESS_NODE node)
{
	node =SANITIZE_PARENT_NODE(SANITIZE_PARENT_NODE(node)->u1.Parent);
	return node;
}
int rb_color(PMMADDRESS_NODE node)
{
	return node->u1.Balance;
}
int rb_is_red(PMMADDRESS_NODE node)
{
	return node->u1.Balance==rb_red;
}
int rb_is_black(PMMADDRESS_NODE node)
{
	return node->u1.Balance==rb_black;
}
void rb_set_black(PMMADDRESS_NODE node)
{
	node->u1.Balance = rb_black;
}
void rb_set_red(PMMADDRESS_NODE node)
{
	node->u1.Balance = rb_red;
}
void rb_set_parent( PMMADDRESS_NODE rb,PMMADDRESS_NODE p)
{
	rb->u1.Parent =(PMMADDRESS_NODE)(((ULONG_PTR)(p)) + ((ULONG_PTR)(rb->u1.Balance)));
}

void rb_set_color( PMMADDRESS_NODE rb, int color) 
{  
	rb->u1.Balance = color;  
}  

void rb_set_parent_color(PMMADDRESS_NODE rb, PMMADDRESS_NODE p,int color)
{
	rb->u1.Parent =p;
	rb->u1.Balance=color;
}

void
	__rb_change_child(PMMADDRESS_NODE old, PMMADDRESS_NODE newer,
	PMMADDRESS_NODE parent, PMM_AVL_TABLE root)
{
	if (parent!=&root->BalancedRoot) {
		if (parent->LeftChild== old){
			parent->LeftChild = newer;			
		}
		else
			parent->RightChild = newer;
	} else
		root->BalancedRoot.RightChild = newer;
}

void __rb_rotate_set_parents(PMMADDRESS_NODE old, PMMADDRESS_NODE newer,
							 PMM_AVL_TABLE root, int color)
{
	PMMADDRESS_NODE parent = rb_parent(old);
	rb_set_color(newer,rb_color(old));
	rb_set_parent(newer,rb_parent(old));
	rb_set_parent_color(old, newer, color);
	__rb_change_child(old, newer, parent, root);
}


static PMMADDRESS_NODE __rb_erase_augmented(PMMADDRESS_NODE node, PMM_AVL_TABLE root)
{
	PMMADDRESS_NODE  child = node->RightChild, tmp = node->LeftChild;
	PMMADDRESS_NODE  parent, rebalance;
	PMMADDRESS_NODE pc;

	if (!tmp) {
		/*
		* Case 1: node to erase has no more than 1 child (easy!)
		*
		* Note that if there is one child it must be red due to 5)
		* and node must be black due to 4). We adjust colors locally
		* so as to bypass __rb_erase_color() later on.
		*/
		pc = node->u1.Parent;
		parent = rb_parent(node);
		__rb_change_child(node, child, parent, root);
		if (child) {
			child->u1.Parent = pc;
			child->u1.Balance=(((ULONG_PTR)(pc)) & 0x1);
			rebalance = &root->BalancedRoot;
		} else
			rebalance = (((ULONG_PTR)(pc)) & 0x1)==0 ? parent : &root->BalancedRoot;
	} else if (!child) {
		/* Still case 1, but this time the child is node->rb_left */
		tmp->u1.Parent =pc= node->u1.Parent;
		tmp->u1.Balance=node->u1.Balance;
		parent = rb_parent(node);
		__rb_change_child(node, tmp, parent, root);
		rebalance = &root->BalancedRoot;
	} else {
		PMMADDRESS_NODE successor = child, child2;
		tmp = child->LeftChild;
		if (!tmp) {
			/*
			* Case 2: node's successor is its right child
			*
			*    (n)          (s)
			*    / \          / \
			*  (x) (s)  ->  (x) (c)
			*        \
			*        (c)
			*/
			parent = successor;
			child2 = successor->RightChild;
		} else {
			/*
			* Case 3: node's successor is leftmost under
			* node's right child subtree
			*
			*    (n)          (s)
			*    / \          / \
			*  (x) (y)  ->  (x) (y)
			*      /            /
			*    (p)          (p)
			*    /            /
			*  (s)          (c)
			*    \
			*    (c)
			*/
			do {
				parent = successor;
				successor = tmp;
				tmp = tmp->LeftChild;
			} while (tmp);
			parent->LeftChild = child2 = successor->RightChild;
			successor->RightChild = child;
			rb_set_parent(child, successor);
		}

		successor->LeftChild = tmp = node->LeftChild;
		rb_set_parent(tmp, successor);
		pc = node->u1.Parent;
		tmp = SANITIZE_PARENT_NODE(pc);
		__rb_change_child(node, successor, tmp, root);
		if (child2) {
			successor->u1.Parent = pc;
			successor->u1.Balance = (((ULONG_PTR)(pc)) & 0x1);
			rb_set_parent_color(child2, parent, rb_black);
			rebalance = &root->BalancedRoot;
		} else {
			PMMADDRESS_NODE pc2 = successor->u1.Parent;
			successor->u1.Parent = pc;
			successor->u1.Balance = (((ULONG_PTR)(pc)) & 0x1);
			rebalance = (((ULONG_PTR)(pc2)) & 0x1)==0 ? parent : &root->BalancedRoot;
		}
		tmp = successor;
	}
	return rebalance;
}

static void
	____rb_erase_color(PMMADDRESS_NODE  parent, PMM_AVL_TABLE root)
{
	PMMADDRESS_NODE node =NULL, sibling, tmp1=NULL, tmp2=NULL;

	while (1) {
		/*
		* Loop invariants:
		* - node is black (or NULL on first iteration)
		* - node is not the root (parent is not NULL)
		* - All leaf paths going through parent and node have a
		*   black node count that is 1 lower than other leaf paths.
		*/
		sibling = parent->RightChild;
		if (node != sibling) {	/* node == parent->rb_left */
			if (rb_is_red(sibling)) {
				/*
				* Case 1 - left rotate at parent
				*
				*     P               S
				*    / \             / \
				*   N   s    -->    p   Sr
				*      / \         / \
				*     Sl  Sr      N   Sl
				*/
				parent->RightChild = tmp1 = sibling->LeftChild;				
				sibling->LeftChild = parent;
				if(tmp1)
					rb_set_parent_color(tmp1, parent, rb_black);
				__rb_rotate_set_parents(parent, sibling, root,
					rb_red);
				sibling = tmp1;
			}
			tmp1 = sibling->RightChild;
			if (!tmp1 || rb_is_black(tmp1)) {
					tmp2 = sibling->LeftChild;
				if (!tmp2 || rb_is_black(tmp2)) {
					/*
					* Case 2 - sibling color flip
					* (p could be either color here)
					*
					*    (p)           (p)
					*    / \           / \
					*   N   S    -->  N   s
					*      / \           / \
					*     Sl  Sr        Sl  Sr
					*
					* This leaves us violating 5) which
					* can be fixed by flipping p to black
					* if it was red, or by recursing at p.
					* p is red when coming from Case 1.
					*/
						rb_set_parent_color(sibling, parent,
						rb_red);
					if (rb_is_red(parent))
						rb_set_black(parent);
					else {
						node = parent;
						parent = rb_parent(node);
						if (parent!=&root->BalancedRoot)
							continue;
					}
					break;
				}
				/*
				* Case 3 - right rotate at sibling
				* (p could be either color here)
				*
				*   (p)           (p)
				*   / \           / \
				*  N   S    -->  N   Sl
				*     / \             \
				*    sl  Sr            s
				*                       \
				*                        Sr
				*/
				sibling->LeftChild = tmp1 = tmp2->RightChild;
				tmp2->RightChild = sibling;
				parent->RightChild = tmp2;
				if (tmp1)
					rb_set_parent_color(tmp1, sibling,
					rb_black);
				tmp1 = sibling;
				sibling = tmp2;
			}
			/*
			* Case 4 - left rotate at parent + color flips
			* (p and sl could be either color here.
			*  After rotation, p becomes black, s acquires
			*  p's color, and sl keeps its color)
			*
			*      (p)             (s)
			*      / \             / \
			*     N   S     -->   P   Sr
			*        / \         / \
			*      (sl) sr      N  (sl)
			*/
			parent->RightChild = tmp2 = sibling->LeftChild;
			sibling->LeftChild = parent;
			rb_set_parent_color(tmp1, sibling, rb_black);
			if (tmp2)
				rb_set_parent(tmp2, parent);
			__rb_rotate_set_parents(parent, sibling, root,
				rb_black);
			break;
		} else {
			sibling = parent->LeftChild;
			if (rb_is_red(sibling)) {
				/* Case 1 - right rotate at parent */
				parent->LeftChild = tmp1 = sibling->RightChild;
				sibling->RightChild = parent;
				rb_set_parent_color(tmp1, parent, rb_black);
				__rb_rotate_set_parents(parent, sibling, root,
					rb_red);
				sibling = tmp1;
			}
			tmp1 = sibling->LeftChild;
			if (!tmp1 || rb_is_black(tmp1)) {
				tmp2 = sibling->RightChild;
				if (!tmp2 || rb_is_black(tmp2)) {
					/* Case 2 - sibling color flip */
					rb_set_parent_color(sibling, parent,
						rb_red);
					if (rb_is_red(parent))
						rb_set_black(parent);
					else {
						node = parent;
						parent = rb_parent(node);
						if (parent!=&root->BalancedRoot)
							continue;
					}
					break;
				}
				/* Case 3 - right rotate at sibling */
				sibling->RightChild = tmp1 = tmp2->LeftChild;
				tmp2->LeftChild = sibling;
				parent->LeftChild = tmp2;
				if (tmp1)
					rb_set_parent_color(tmp1, sibling,
					rb_black);
				tmp1 = sibling;
				sibling = tmp2;
			}
			/* Case 4 - left rotate at parent + color flips */
			parent->LeftChild = tmp2 = sibling->RightChild;
			sibling->RightChild = parent;
			rb_set_parent_color(tmp1, sibling, rb_black);
			if (tmp2)
				rb_set_parent(tmp2, parent);
			__rb_rotate_set_parents(parent, sibling, root,
				rb_black);
			break;
		}
	}
}

void rb_rotate_left(PMMADDRESS_NODE node, PMM_AVL_TABLE Table) 
{   
    PMMADDRESS_NODE r = node->RightChild;
	PMMADDRESS_NODE parent = rb_parent(node);   
  
    if ((node->RightChild = r->LeftChild))   
        rb_set_parent(node->RightChild, node);   
  
    r->LeftChild = node;   
    rb_set_parent(node, r);   
  
    if (parent) {   
        if (node == parent->LeftChild)   
            parent->LeftChild = r;   
        else  
            parent->RightChild = r;   
    } else {   
        Table->BalancedRoot.RightChild = r;   
    }   
    rb_set_parent(r, parent);   
}   

void rb_rotate_right(PMMADDRESS_NODE node, PMM_AVL_TABLE Table) 
{   
    PMMADDRESS_NODE l = node->LeftChild;
	PMMADDRESS_NODE parent = rb_parent(node);   
  
    if ((node->LeftChild = l->RightChild))   
        rb_set_parent(node->LeftChild, node);   
  
    l->RightChild = node;   
    rb_set_parent(node, l);   
  
    if (parent) {   
        if (node == parent->LeftChild)   
            parent->LeftChild = l;   
        else  
            parent->RightChild = l;   
    } else {   
        Table->BalancedRoot.RightChild = l;   
    }   
    rb_set_parent(l, parent);   
}

void rb_erase_color(PMMADDRESS_NODE node, PMMADDRESS_NODE parent, PMM_AVL_TABLE Table) 
{   

    PMMADDRESS_NODE other;   

    while ((!node || rb_is_black(node)) && node != Table->BalancedRoot.RightChild) 
	{   
 
        if (parent->LeftChild == node) 
		{   
            other = parent->RightChild;   
            if (rb_is_red(other)) {   

                rb_set_black(other);   
                rb_set_red(parent);   
                rb_rotate_left(parent, Table);   
                other = parent->RightChild;   
            }   

            if ((!other->LeftChild || rb_is_black(other->LeftChild)) &&   
                (!other->RightChild || rb_is_black(other->RightChild))) 
			{   
                rb_set_red(other);   
                node = parent;   
                parent = rb_parent(node);   
            } 
			else 
			{   
                if (!other->RightChild || rb_is_black(other->RightChild)) {   

                    rb_set_black(other->LeftChild);   
                    rb_set_red(other);   
                    rb_rotate_right(other, Table);   
                    other = parent->RightChild;   
                }   
 
                rb_set_color(other, rb_color(parent));   
                rb_set_black(parent);   
                rb_set_black(other->RightChild);   
                rb_rotate_left(parent, Table);   
 
                node = Table->BalancedRoot.RightChild;   
                break;   
            }   
        } 
		else 
		{   
            other = parent->LeftChild;   
            if (rb_is_red(other)) 
			{   
                rb_set_black(other);   
                rb_set_red(parent);   
                rb_rotate_right(parent, Table);   
                other = parent->LeftChild;   
            }   
            if ((!other->LeftChild || rb_is_black(other->LeftChild)) &&   
                (!other->RightChild || rb_is_black(other->RightChild))) 
			{   
                rb_set_red(other);   
                node = parent;   
                parent = rb_parent(node);   
            } 
			else 
			{   
                if (!other->LeftChild || rb_is_black(other->LeftChild)) 
				{   
                    rb_set_black(other->RightChild);   
                    rb_set_red(other);   
                    rb_rotate_left(other, Table);   
                    other = parent->LeftChild;   
                }   
				
                rb_set_color(other, rb_color(parent));   
                rb_set_black(parent);   
                rb_set_black(other->LeftChild);   
                rb_rotate_right(parent, Table);  
				
                node = Table->BalancedRoot.RightChild;   
                break;   
            }   
        }   
    }   

    if (node)   
        rb_set_black(node);   
}

void MiInsertNode ( PMMADDRESS_NODE NodeToInsert, PMM_AVL_TABLE Table)


{
	PMMADDRESS_NODE NodeOrParent;
	PMMADDRESS_NODE parent,gparent,tmp;
	TABLE_SEARCH_RESULT SearchResult;

	SearchResult = MiFindNodeOrParent (Table,
		NodeToInsert->StartingVpn,
		&NodeOrParent);

	NodeToInsert->LeftChild = NULL;
	NodeToInsert->RightChild = NULL;

	Table->NumberGenericTableElements += 1;

	//
	// Insert the newer node in the tree.
	//

	if (SearchResult == TableEmptyTree) 
	{
		Table->BalancedRoot.RightChild = NodeToInsert;
		rb_set_parent(NodeToInsert,&Table->BalancedRoot);
	}
	else 
	{
		if (SearchResult == TableInsertAsLeft) 
		{
			NodeOrParent->LeftChild = NodeToInsert;
		}
		else 
		{
			NodeOrParent->RightChild = NodeToInsert;
		}
		rb_set_parent(NodeToInsert,NodeOrParent);
	}	
	rb_set_red(NodeToInsert);
	parent=rb_parent(NodeToInsert);
	while(1)  {
		if (parent==&Table->BalancedRoot) {
			Table->BalancedRoot.RightChild = NodeToInsert;
			rb_set_parent_color(NodeToInsert,&Table->BalancedRoot,rb_black);
			break;
		} else if (rb_is_black(parent))
			break;
		gparent = rb_parent(parent);
		tmp = gparent->RightChild;

		if (parent != tmp) {	/* parent == gparent->rb_left */
			if (tmp && rb_is_red(tmp)) {
				/*
				* Case 1 - color flips
				*
				*       G            g
				*      / \          / \
				*     p   u  -->   P   U
				*    /            /
				*   n            n
				*
				* However, since g's parent might be red, and
				* 4) does not allow this, we need to recurse
				* at g.
				*/
				rb_set_parent_color(tmp, gparent, rb_black);
				rb_set_parent_color(parent, gparent, rb_black);
				NodeToInsert = gparent;
				parent = rb_parent(NodeToInsert);
				rb_set_parent_color(NodeToInsert, parent, rb_red);
				continue;
			}

			tmp = parent->RightChild;
			if (NodeToInsert == tmp) {
				/*
				* Case 2 - left rotate at parent
				*
				*      G             G
				*     / \           / \
				*    p   U  -->    n   U
				*     \           /
				*      n         p
				*
				* This still leaves us in violation of 4), the
				* continuation into Case 3 will fix that.
				*/
				parent->RightChild = tmp = NodeToInsert->LeftChild;
				NodeToInsert->LeftChild = parent;
				if (tmp)
					rb_set_parent_color(tmp, parent,rb_black);
				rb_set_parent_color(parent, NodeToInsert, rb_red);
				parent = NodeToInsert;
				tmp = NodeToInsert->RightChild;
			}

			/*
			* Case 3 - right rotate at gparent
			*
			*        G           P
			*       / \         / \
			*      p   U  -->  n   g
			*     /                 \
			*    n                   U
			*/
			gparent->LeftChild= tmp;  /* == parent->rb_right */
			parent->RightChild= gparent;
			if (tmp)
				rb_set_parent_color(tmp, gparent, rb_black);
			__rb_rotate_set_parents(gparent, parent, Table, rb_red);
			break;
		} else {
			tmp = gparent->LeftChild;
			if (tmp && rb_is_red(tmp)) {
				/* Case 1 - color flips */
				rb_set_parent_color(tmp, gparent, rb_black);
				rb_set_parent_color(parent, gparent, rb_black);
				NodeToInsert = gparent;
				parent = rb_parent(NodeToInsert);
				rb_set_parent_color(NodeToInsert, parent, rb_red);
				continue;
			}

			tmp = parent->LeftChild;
			if (NodeToInsert == tmp) {
				/* Case 2 - right rotate at parent */
				parent->LeftChild = tmp = NodeToInsert->RightChild;
				NodeToInsert->RightChild = parent;
				if (tmp)
					rb_set_parent_color(tmp, parent,
					rb_black);
				rb_set_parent_color(parent, NodeToInsert, rb_red);
				parent = NodeToInsert;
				tmp = NodeToInsert->LeftChild;
			}

			/* Case 3 - left rotate at gparent */
			gparent->RightChild = tmp;  /* == parent->rb_left */
			parent->LeftChild = gparent;
			if (tmp)
				rb_set_parent_color(tmp, gparent, rb_black);
			__rb_rotate_set_parents(gparent, parent, Table, rb_red);
			break;
		}
	}
	return;
}

void MiRemoveNode (
	PMMADDRESS_NODE NodeToDelete,
	PMM_AVL_TABLE Table
	)
{
	PMMADDRESS_NODE rebalance;
	Table->NumberGenericTableElements -= 1;
	rebalance = __rb_erase_augmented(NodeToDelete, Table);
	if (rebalance!=&Table->BalancedRoot&&rebalance)
		____rb_erase_color(rebalance, Table);

}

